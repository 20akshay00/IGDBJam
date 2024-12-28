extends Area2D
class_name Lock

var _key_tween: Tween = null

func _on_body_entered(body: Node2D) -> void:
	if body is Key: 
		if body.lock == self and not body._is_encrypted:			
			await get_tree().create_timer(1).timeout
			AudioManager.play_effect(AudioManager.valid_placement_sfx)
			if _key_tween: _key_tween.kill()
			_key_tween = get_tree().create_tween()
			_key_tween.tween_property(body.get_node("Background"), "modulate", Config.SUCCESS_COLOR, 0.3)
			await _key_tween.finished
			EventManager.lock_activated.emit(self)

		else:
			await get_tree().create_timer(1).timeout
			AudioManager.play_effect(AudioManager.invalid_placement_sfx)

func _on_body_exited(body: Node2D) -> void:
	if body is Key and body.lock == self and not body._is_encrypted:
		EventManager.lock_deactivated.emit(self)
		if _key_tween: _key_tween.kill()
		_key_tween = get_tree().create_tween()
		_key_tween.tween_property(body.get_node("Background"), "modulate", Config.DEFAULT_COLOR, 0.3)
