extends GridObject
class_name Block

@onready var _move_tween: Tween = null 
@onready var _tile_map: TileMapLayer = get_parent()

@export var _sliding_animation_sec := 0.5

var _is_sliding := false

func push(source: Node2D, direction: Vector2) -> void:
	if source is MoverProcess:
		if _is_sliding: return
		var destination: Vector2 = position + direction * Vector2(_tile_map.tile_set.tile_size)
		if _tile_map.is_empty(destination):
			_tile_map.update_grid(position, destination)
			if _move_tween: _move_tween.kill()
			_move_tween = create_tween()
			_move_tween.tween_property(self, "position", destination, _sliding_animation_sec)	
			_is_sliding = true
			await _move_tween.finished
			_is_sliding = false
			
			if self is Key:
				AudioManager.play_effect(AudioManager.key_move_sfx)
			else:
				AudioManager.play_effect(AudioManager.light_block_move_sfx)
