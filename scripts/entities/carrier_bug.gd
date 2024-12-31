extends ControllableEntity
class_name CarrierBug

var _is_sliding := false
@export var _sliding_animation_sec := 0.4

func _ready() -> void:
	set_active(true)
	EventManager.tick.connect(_on_tick)

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

			AudioManager.play_effect(AudioManager.heavy_block_move_sfx)
