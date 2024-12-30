extends ControllableEntity
class_name MoverProcess

var count := 4

func _ready() -> void:
	EventManager.tick.connect(_on_tick)
	_current_direction = Vector2(1, 0)

func set_active_hook(val: bool) -> void:
	_current_direction = Vector2(cos(sprite.rotation), sin(sprite.rotation))

func _on_tick() -> void:
	if not _is_active:
		count += 1
		if count == 3: 
			count = 0
			_current_direction.x *= -1
			
		_custom_move(_current_direction)
		sprite.rotation = _current_direction.x * PI/2 - PI/2

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
		# push keys and blocks
		var object = raycast.get_collider()
		if object is GridObject:
			if randf() < 0.5: object.push(self, dir)
			else: _current_direction.x *= -1; count = 0;
		# push carrier bug
		elif object is CarrierBug and not object._is_active:
			if randf() < 0.5: object.push(self, dir)
			else: _current_direction.x *= -1; count = 0;

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
