extends ControllableEntity
class_name DecryptProcess

@export var max_count := 4
var count := 0
@export var _init_dir := Vector2.ZERO

var _is_decrypting := false

func _ready() -> void:
	EventManager.tick.connect(_on_tick)
	if _init_dir != Vector2.ZERO:
		_current_direction = _init_dir
	else:	
		_current_direction = [Vector2(1, 0), Vector2(0, 1)].pick_random()
	
	sprite.rotation = atan2(_current_direction.y, _current_direction.x)

func set_active_hook(val: bool) -> void:
	_current_direction = Vector2(cos(sprite.rotation), sin(sprite.rotation))

func _on_tick() -> void:
	if not _is_active and not _is_decrypting:
		count += 1
		if count == max_count - 1:
			count = 0
			_current_direction *= -1
			
		_custom_move(_current_direction)

func _custom_move(dir: Vector2) -> void:
	raycast.target_position = dir * _tile_size
	raycast.force_raycast_update()
	
	var target_position := position + dir * _tile_size

	# rotate sprite
	if abs(dir.dot(Vector2(cos(sprite.rotation), sin(sprite.rotation))) - 1) > 0.01:
		if _move_tween: _move_tween.kill()
		_move_tween = create_tween()
		var angle = lerp_angle(sprite.rotation, atan2(dir.y, dir.x), 1) 
		_move_tween.tween_property(sprite, "rotation", angle, _rotation_animation_sec)
	
	# push blocks and carrier bug
	elif raycast.is_colliding():
		_current_direction *= -1; 
		count = 0;

	# move tween
	if not raycast.is_colliding() and _tile_map.is_empty(target_position):
		_tile_map.update_grid(position, target_position)
		_move_tween = create_tween()
		_move_tween.tween_property(self, "position",
			position + dir * _tile_size, _move_animation_sec).set_trans(Tween.TRANS_SINE)
		_is_moving = true
		await _move_tween.finished
		_is_moving = false
		move_completed.emit()
		return
	move_completed.emit()


func _on_move_timer_timeout() -> void:
	_can_move = true
