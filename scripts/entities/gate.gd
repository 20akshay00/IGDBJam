extends Area2D
class_name Gate

@export var locks: Array[Lock]
@onready var _tile_map: TileMapLayer = get_parent()

var unlock_indices: Array[int] = []

func _ready() -> void:
	EventManager.lock_activated.connect(_on_lock_activated)
	EventManager.lock_deactivated.connect(_on_lock_deactivated)

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
		$Sprite2D.hide()
		$CollisionShape2D.disabled = true
		_tile_map.remove_occupation(position)
	elif not $Sprite2D.visible and _tile_map.is_empty(position):
		$Sprite2D.show()
		$CollisionShape2D.disabled = false
		_tile_map.add_occupation(position)
