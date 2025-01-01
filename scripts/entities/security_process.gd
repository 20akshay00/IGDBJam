extends ControllableEntity
class_name SecurityProcess

@export var _num_inactive_target_ticks_max := 6
@export var num_ticks_detect := 6
var start_tick := 0

@export var max_count := 4
@export var _init_dir := Vector2.ZERO

var count := 0

var target: ControllableEntity = null

var NORMAL_COLOR := Color("#35c20a4c")
var DETECTED_COLOR := Color("fd6d724c") 

var _detection_tween: Tween = null
var _num_inactive_target_ticks := -1

func _ready() -> void:
	EventManager.tick.connect(_on_tick)
	_current_direction = Vector2(1, 0)

	var shape := ConvexPolygonShape2D.new()
	shape.points = $DetectionArea/Polygon2D.polygon
	$DetectionArea/CollisionShape2D.shape = shape
	
	if _init_dir != Vector2.ZERO:
		_current_direction = _init_dir
	else:	
		_current_direction = [Vector2(1, 0), Vector2(0, 1)].pick_random()
	
	sprite.rotation = atan2(_current_direction.y, _current_direction.x)
	$DetectionArea.rotation = sprite.rotation 

func set_active_hook(val: bool) -> void:
	_current_direction = Vector2(cos(sprite.rotation), sin(sprite.rotation))

func _on_tick() -> void:
	if not _is_active:
		if target == null:
			count += 1
			if count == max_count - 1: 
				count = 0
				_current_direction *= -1
		else:
			if target._is_active:
				# start tracking how many ticks since the target became inactive
				if _num_inactive_target_ticks == -1:
					_num_inactive_target_ticks = 0
				
				# track how many ticks the active target is under direct line of sight
				if target in $DetectionArea.get_overlapping_bodies(): 
					EventManager.detected_on_tick.emit()
			else: 
				# if target is not active, keep track of how many ticks passed since then
				_num_inactive_target_ticks += 1
				if _num_inactive_target_ticks >= _num_inactive_target_ticks_max:
					_on_timer_timeout()
			
			if target: _current_direction = _tile_map.get_next_dir_to(position, target.position)
			if (start_tick != -1 and ((EventManager.ticks - start_tick) >= num_ticks_detect)):
				_on_timer_timeout()
			
		_custom_move(_current_direction)

func _custom_move(dir: Vector2) -> void:
	raycast.target_position = dir * _tile_size
	raycast.force_raycast_update()
	
	var target_position := position + dir * _tile_size

	# rotate sprite
	if abs(dir.dot(Vector2(cos(sprite.rotation), sin(sprite.rotation))) - 1) > 0.01:
		if _move_tween: _move_tween.kill()
		_move_tween = create_tween()
		_move_tween.set_parallel()
		var angle = lerp_angle(sprite.rotation, atan2(dir.y, dir.x), 1) 
		_move_tween.tween_property(sprite, "rotation", angle, _rotation_animation_sec)
		_move_tween.tween_property($DetectionArea, "rotation", angle, _rotation_animation_sec)

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

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is ControllableEntity:
		if body._is_active or (body is DecryptProcess and body._is_decrypting):
			target = body
			_on_detection()
			start_tick = -1
			EventManager.is_detected = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is ControllableEntity:
		if body._is_active:
			start_tick = EventManager.ticks

func _on_detection() -> void:
	$DetectionArea/Polygon2D.color = DETECTED_COLOR
	if _detection_tween: _detection_tween.kill()
	_detection_tween = get_tree().create_tween()
	_detection_tween.set_loops()
	_detection_tween.tween_property($DetectionArea/Polygon2D, "modulate:a", 0.5, 0.5)
	_detection_tween.tween_property($DetectionArea/Polygon2D, "modulate:a", 1, 0.5)
	
func _on_timer_timeout() -> void:
	$DetectionArea/Polygon2D.color = NORMAL_COLOR
	_detection_tween.kill()
	target = null
	_num_inactive_target_ticks = -1
	_current_direction = [Vector2(1, 0), Vector2(0, 1)].pick_random()
	count = 0
	EventManager.is_detected = false


func _on_move_timer_timeout() -> void:
	_can_move = true
