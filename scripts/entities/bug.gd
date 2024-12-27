extends CharacterBody2D

@onready var raycast := $RayCast2D
@onready var sprite := $Sprite2D

@export var _move_animation_sec := 0.3
@export var _rotation_animation_sec := 0.1

var _tile_size := 64
var _valid_inputs := {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN}

var _is_moving := false
var _move_tween: Tween = null

var _current_direction := Vector2(1, 0)

func _process(delta: float) -> void:
	if _is_moving: return
	
	for direction_key in _valid_inputs.keys():
		if Input.is_action_pressed(direction_key):
			_current_direction = _valid_inputs[direction_key]
			_move(_current_direction)

func _move(dir: Vector2) -> void:
	raycast.target_position = dir * _tile_size
	raycast.force_raycast_update()

	if abs(_current_direction.dot(Vector2(cos(sprite.rotation), sin(sprite.rotation))) - 1) > 0.01:
		if _move_tween: _move_tween.kill()
		_move_tween = create_tween()
		var angle = lerp_angle(sprite.rotation, atan2(dir.y, dir.x), 1) 
		_move_tween.tween_property(sprite, "rotation", angle, _rotation_animation_sec)
	else:
		if !raycast.is_colliding():
			_move_tween = create_tween()
			_move_tween.tween_property(self, "position",
				position + dir * _tile_size, _move_animation_sec).set_trans(Tween.TRANS_SINE)
			_is_moving = true
			await _move_tween.finished
			_is_moving = false
		else:
			var object := raycast.get_collider() as GridObject
			if object:
				object.push(source, dir)
