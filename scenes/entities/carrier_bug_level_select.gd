extends CharacterBody2D

var _is_sliding := false
@export var _sliding_animation_sec := 0.4

@onready var raycast := $RayCast2D
@onready var sprite: Node2D = $Sprites
@onready var _tile_map: TileMapLayer = get_parent()
@onready var _move_timer: Timer = $MoveTimer

@export var _move_animation_sec := 0.3
@export var _rotation_animation_sec := 0.15
@export var _sprite_animation_sec := 0.5

var _tile_size := 64
var _valid_inputs := {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN}

var _is_moving := false

var _move_tween: Tween = null
var _sprite_tween: Tween = null

var _current_direction := Vector2(1, 0)

var _is_active := false
var _can_infect := true

var _can_move := true
	
func _process(delta: float) -> void:
	#queue_redraw()
	if _is_moving: return
	# movement using user input
	for direction_key in _valid_inputs.keys():
		if Input.is_action_pressed(direction_key):
			_current_direction = _valid_inputs[direction_key]
			_move(_current_direction)
			return

func _move(dir: Vector2) -> void:
	raycast.target_position = dir * _tile_size
	raycast.force_raycast_update()
	
	var target_position := position + dir * _tile_size

	# rotate sprite
	if abs(dir.dot(Vector2(cos(sprite.rotation), sin(sprite.rotation))) - 1) > 0.01:
		if _move_tween: _move_tween.kill()
		_move_tween = create_tween()
		var angle = lerp_angle(sprite.rotation, atan2(dir.y, dir.x), 1) 
		_move_tween.tween_property(sprite, "rotation", angle, _rotation_animation_sec)

	# move tween
	if not raycast.is_colliding():
		if _tile_map.is_empty(target_position):
			_tile_map.update_grid(position, target_position)
			_move_tween = create_tween()
			_move_tween.tween_property(self, "position",
				position + dir * _tile_size, _move_animation_sec).set_trans(Tween.TRANS_SINE)
			_is_moving = true
			await _move_tween.finished
			_is_moving = false
	#elif raycast.get_collider() is TileMapLayer:
		#AudioManager.play_effect(AudioManager.invalid_placement_sfx)
		#
