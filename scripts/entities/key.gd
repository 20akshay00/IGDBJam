extends GridObject
class_name Key

@onready var _move_tween: Tween = null 
@onready var _tile_map: TileMapLayer = get_parent()

@export var _sliding_animation_sec := 0.5

var _is_sliding := false

func push(source: Node2D, direction: Vector2) -> void:
	if source is MoverProcess:
		if _is_sliding: return
		var destination: Vector2 = position + direction * Vector2(_tile_map.tile_set.tile_size)
		if _is_valid_move(destination):
			if _move_tween: _move_tween.kill()
			_move_tween = create_tween()
			_move_tween.tween_property(self, "position", destination, _sliding_animation_sec)	
			_is_sliding = true
			await _move_tween.finished
			_is_sliding = false

func _is_valid_move(position: Vector2) -> bool:
	return true
