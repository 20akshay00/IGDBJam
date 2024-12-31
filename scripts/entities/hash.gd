extends Area2D
class_name Hash

var _key_tween: Tween = null
var _rect: Rect2 

var _hash_code: Array[int] = []
var code_ui_scene: PackedScene = preload("res://scenes/ui/codedisplay_ui.tscn")
var code_ui 

enum CHARS {UP, DOWN}
var char_textures = [preload("res://assets/art/arrowUp.png"), preload("res://assets/art/arrowDown.png")]

var _code_tween: Tween = null

func _ready() -> void:
	_rect = $Overlay.region_rect
	code_ui = code_ui_scene.instantiate()
	code_ui.z_index = 5
	add_child(code_ui)

func _on_body_entered(body: Node2D) -> void:
	if body is DecryptProcess: 
		await get_tree().create_timer(0.25).timeout
		
		for idx in _hash_code.size():			
			code_ui.get_node("Glyphs").get_child(idx).texture = char_textures[_hash_code[idx]]
		
		if _code_tween: _code_tween.kill()
		_code_tween = get_tree().create_tween()
		_code_tween.tween_property($CodeDisplayUI, "modulate:a", 1.0, 0.3)
		
		$Overlay.region_rect = Rect2(_rect.position - Vector2(0, _rect.size.y), _rect.size)
		if _key_tween: _key_tween.kill()
		_key_tween = get_tree().create_tween()
		_key_tween.tween_property($Overlay, "modulate:a", 1.0, 0.3)
		AudioManager.play_effect(AudioManager.valid_placement_sfx)
	else:
		await get_tree().create_timer(0.25).timeout
		
		$Overlay.region_rect = _rect
		if _key_tween: _key_tween.kill()
		_key_tween = get_tree().create_tween()
		_key_tween.tween_property($Overlay, "modulate:a", 1.0, 0.3)
		
		AudioManager.play_effect(AudioManager.invalid_placement_sfx)

func _on_body_exited(body: Node2D) -> void:

	if _key_tween: _key_tween.kill()
	_key_tween = get_tree().create_tween()
	_key_tween.tween_property($Overlay, "modulate:a", 0., 0.3)

	if _code_tween: _code_tween.kill()
	_code_tween = get_tree().create_tween()
	_code_tween.tween_property($CodeDisplayUI, "modulate:a", 0., 0.3)

func set_hash(val: Array[int]):
	_hash_code = val
