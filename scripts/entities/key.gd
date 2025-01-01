extends Block
class_name Key

@export var lock: Lock
@export var color: Config.color_index
@export var _chain_animation_sec := 0.5
@export var _is_encrypted := false

@export var hash: Hash

var code_ui_scene: PackedScene = preload("res://scenes/ui/codedisplay_ui.tscn")
var code_ui 

enum CHARS {UP, DOWN}
var char_textures = [preload("res://assets/art/arrowDown.png"), preload("res://assets/art/arrowUp.png")]

var _hash_code: Array[int] = []
var _chain_tween: Tween = null
var _code_tween: Tween = null
var _underlay_tween: Tween = null

var _is_decrypting := false
var code_input: Array[int] = []
var decrypt_bot: DecryptProcess = null
var _can_be_decrypted := true

var minigame_delay_sec := 0.15

func _ready() -> void:
	var rect = $Sprite.region_rect
	$Sprite.region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)

	rect = $ChainedSprite.region_rect
	$ChainedSprite.region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)
	
	rect = lock.get_node("Sprite").region_rect
	lock.get_node("Sprite").region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)
	
	if _is_encrypted:
		
		rect = hash.get_node("Sprite").region_rect
		hash.get_node("Sprite").region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)
	
		_chain_tween = get_tree().create_tween()
		_chain_tween.set_parallel()
		_chain_tween.tween_property($Sprite, "modulate:a", 0., _chain_animation_sec)
		_chain_tween.tween_property($ChainedSprite, "modulate:a", 1., _chain_animation_sec)
		
		for i in 5:
			_hash_code.push_back(randi_range(0, 1))
		
		hash.set_hash(_hash_code)
		code_ui = code_ui_scene.instantiate()
		code_ui.z_index = 5
		add_child(code_ui)

func decrypt(object: DecryptProcess) -> void:
	decrypt_bot = object
	decrypt_bot._is_active = false
	decrypt_bot._is_decrypting = true

	code_input = []
	_is_decrypting = true
	
	_show_glyphs()

func _on_decrypt() -> void:
	AudioManager.play_effect(AudioManager.valid_placement_sfx)

	decrypt_bot._is_active = true
	decrypt_bot._is_decrypting = false
	_can_be_decrypted = false
	
	if _underlay_tween: _underlay_tween.kill()
	_underlay_tween = get_tree().create_tween()
	_underlay_tween.tween_property($Underlay, "modulate:a", 0., 0.3)
	
	if _code_tween: _code_tween.kill()
	_code_tween = get_tree().create_tween()
	_code_tween.tween_property(code_ui, "modulate", Config.SUCCESS_COLOR, 0.3)
	_code_tween.tween_property(code_ui, "scale", Vector2(1.1, 1.1), 0.2)
	_code_tween.tween_property(code_ui, "scale", Vector2(1, 1), 0.2)
	await _code_tween.finished

	_hide_glyphs()
	
	_is_encrypted = false
	_chain_tween = get_tree().create_tween()
	_chain_tween.set_parallel()
	_chain_tween.tween_property($Sprite, "modulate:a", 1., _chain_animation_sec)
	_chain_tween.tween_property($ChainedSprite, "modulate:a", 0., _chain_animation_sec)
	lock._on_body_inside()

func _abort_decryption() -> void:
	AudioManager.play_effect(AudioManager.invalid_placement_sfx)
	decrypt_bot._is_active = true
	decrypt_bot._is_decrypting = false
	_can_be_decrypted = false

	if _code_tween: _code_tween.kill()
	_code_tween = get_tree().create_tween()
	_code_tween.tween_property(code_ui, "modulate", Config.FAILURE_COLOR, 0.3)
	_code_tween.tween_property(code_ui, "scale", Vector2(1.1, 1.1), 0.2)
	_code_tween.tween_property(code_ui, "scale", Vector2(1, 1), 0.2)

	await _code_tween.finished
	_hide_glyphs()

func _on_decrypt_failed() -> void:
	_abort_decryption()

func _show_glyphs() -> void:
	if _code_tween: _code_tween.kill()
	_code_tween = get_tree().create_tween()
	_code_tween.tween_property(code_ui, "modulate:a", 1., 0.3)
	
	if _underlay_tween: _underlay_tween.kill()
	_underlay_tween = get_tree().create_tween()
	_underlay_tween.tween_property($Underlay, "modulate:a", 1.0, 0.15)

func _hide_glyphs() -> void:
	
	if _code_tween: _code_tween.kill()
	_code_tween = get_tree().create_tween()
	_code_tween.tween_property(code_ui, "modulate:a", 0., 0.5)
	
	await _code_tween.finished
	for idx in 5:
		code_ui.get_node("Glyphs").get_child(idx).texture = null

	code_input = []

	code_ui.modulate = Config.DEFAULT_COLOR
	_can_be_decrypted = true

	if _underlay_tween: _underlay_tween.kill()
	_underlay_tween = get_tree().create_tween()
	_underlay_tween.tween_property($Underlay, "modulate:a", 0., 0.1)

func _process(delta: float) -> void:
	if _is_decrypting:
		if len(code_input) < 5:
			if Input.is_action_just_pressed("up"):
				code_input.push_back(0)
				code_ui.get_node("Glyphs").get_child(len(code_input) - 1).texture = char_textures[1]
				AudioManager.play_effect(AudioManager.hash_press_sfx)
				#EventManager.tick_started(self)
			elif Input.is_action_just_pressed("down"):
				code_input.push_back(1)
				code_ui.get_node("Glyphs").get_child(len(code_input) - 1).texture = char_textures[0]
				AudioManager.play_effect(AudioManager.hash_press_sfx)
				#EventManager.tick_started(self)
			elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				_is_decrypting = false
				await get_tree().create_timer(minigame_delay_sec).timeout
				_abort_decryption()
		else:
			_is_decrypting = false
			_hide_glyphs()
			if code_input == _hash_code:
				await get_tree().create_timer(minigame_delay_sec).timeout
				_on_decrypt()
			else:
				await get_tree().create_timer(minigame_delay_sec).timeout
				AudioManager.play_effect(AudioManager.invalid_placement_sfx)
				_on_decrypt_failed()
	else:
		pass
