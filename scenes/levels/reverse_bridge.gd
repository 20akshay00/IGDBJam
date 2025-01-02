extends Node2D

@export var locks: Array[Lock]
@onready var _tile_map: TileMapLayer = get_parent()

var unlock_indices: Array[int] = []
var _filled_tile_atlas_coord = Vector2i(4, 0)
var _empty_tile_atlas_coord = Vector2i(3, 2)

var bridge_positions: Array[Vector2]= []
var bridge_cells: Array[Vector2i] = []

func _ready() -> void:
	EventManager.lock_activated.connect(_on_lock_activated)
	EventManager.lock_deactivated.connect(_on_lock_deactivated)
	
	for child in get_children():
		#_tile_map.set_cell(_tile_map.local_to_map(child.position), 0, _filled_tile_atlas_coord, 0)
		bridge_positions.push_back(child.position)
		bridge_cells.push_back(_tile_map.local_to_map(child.position))

func _on_lock_activated(lock: Lock):
	var idx = locks.find(lock, 0)
	if idx >= 0: 
		unlock_indices.push_back(idx) 
	
	call_deferred("_update_status")

func _on_lock_deactivated(lock: Lock):
	var idx = locks.find(lock, 0)
	if idx >= 0: 
		unlock_indices.erase(idx)

	call_deferred("_update_status")

func _update_status() -> void:
	if len(locks) == len(unlock_indices):
		for pos in bridge_positions:
			_tile_map.set_cell(_tile_map.local_to_map(pos), 0, _empty_tile_atlas_coord, 0)
			_tile_map.remove_occupation(pos)

		if get_tree():
			await get_tree().create_timer(0.5).timeout
			
		for entity in _tile_map.get_children():
			if (entity is not Bridge) and (_tile_map.local_to_map(entity.position) in bridge_cells):
				var entity_tween := get_tree().create_tween()
				entity_tween.tween_property(entity, "modulate:a", 0., 0.75)
				entity_tween.tween_callback(
					func(): 
						if entity is ControllableEntity:
							_tile_map.num_entities -= 1
							#entity.move_finished.emit()
						entity.queue_free()
						await get_tree().create_timer(1.).timeout
						LevelManager.load_level(19)
						)
		
