extends CharacterBody2D
class_name ControllableEntity

signal move_completed

@onready var raycast := $RayCast2D
@onready var sprite: Node2D = $Sprites
@onready var _tile_map: TileMapLayer = get_parent()

@export var _move_animation_sec := 0.3
@export var _rotation_animation_sec := 0.1
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

func _ready() -> void:
	set_active(false)
	EventManager.tick.connect(_on_tick)

#func _draw() -> void:
	#draw_line(Vector2.ZERO, raycast.target_position, Color.RED, 5)

func _process(delta: float) -> void:
	if _is_moving: return
	if _is_active and not EventManager._tick_in_progress:
		# movement using user input
		for direction_key in _valid_inputs.keys():
			if Input.is_action_pressed(direction_key):
				_current_direction = _valid_inputs[direction_key]
				_move(_current_direction)
				EventManager.tick_started(self)
				return

		if Input.is_action_just_pressed("infect") and _can_infect:
			var object = raycast.get_collider()
			# infection mechanic
			if object is ControllableEntity:
				#  is_equal_approx(object._current_direction.dot(_current_direction), -1)
				if (self is CarrierBug and object is not SecurityProcess) or (object is CarrierBug):
					AudioManager.play_effect(AudioManager.virus_sfx)
					set_active(false)
					object.set_active(true)
					return
	
			elif object is Key:
				# decrypt key
				if (self is DecryptProcess) and (object._is_encrypted) and (object._can_be_decrypted):
					object.decrypt(self)

		if Input.is_action_just_pressed("pass"):
			EventManager.tick_started(self)
			return
	else: 
		_default_process(delta)

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
	# push blocks and carrier bug
	elif raycast.is_colliding():
		# push keys and blocks
		var object = raycast.get_collider()
		if object is GridObject: object.push(self, dir)
		
		# push carrier bug
		if object is CarrierBug and not object._is_active: object.push(self, dir)
		
	# move tween
	if not raycast.is_colliding() and _tile_map.is_empty(target_position):
		_tile_map.update_grid(position, target_position)
		_move_tween = create_tween()
		_move_tween.tween_property(self, "position",
			position + dir * _tile_size, _move_animation_sec).set_trans(Tween.TRANS_SINE)
		_is_moving = true
		await _move_tween.finished
		_is_moving = false
		
func _default_process(delta: float) -> void:
	pass

func set_active(val: bool) -> void:
	_is_active = val
	_can_infect = false
	var timer = get_tree().create_timer(1.0).timeout.connect(func(): _can_infect = true)

	if _sprite_tween: _sprite_tween.kill()
	_sprite_tween = create_tween()
	_sprite_tween.set_parallel()
	
	if _is_active:
		_sprite_tween.tween_property(sprite.get_child(0), "modulate:a", 0., _sprite_animation_sec)
		_sprite_tween.tween_property(sprite.get_child(1), "modulate:a", 1., _sprite_animation_sec)
	else:
		_sprite_tween.tween_property(sprite.get_child(0), "modulate:a", 1., _sprite_animation_sec)
		_sprite_tween.tween_property(sprite.get_child(1), "modulate:a", 0., _sprite_animation_sec)

	set_active_hook(val)

func set_active_hook(val: bool) -> void:
	pass

func _on_tick() -> void:
	if not _is_active:
		move_completed.emit()
