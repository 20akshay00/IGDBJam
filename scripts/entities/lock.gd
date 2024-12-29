extends Area2D
class_name Lock

var _key_tween: Tween = null
var _rect: Rect2 

func _ready() -> void:
	_rect = $Overlay.region_rect

func _on_body_entered(body: Node2D) -> void:
	if body is Key: 
		if body.lock == self and not body._is_encrypted:			
			await get_tree().create_timer(0.5).timeout
			AudioManager.play_effect(AudioManager.valid_placement_sfx)
			
			$Overlay.region_rect = _rect
			if _key_tween: _key_tween.kill()
			_key_tween = get_tree().create_tween()
			_key_tween.tween_property($Overlay, "modulate:a", 1.0, 0.15)
			await _key_tween.finished
			EventManager.lock_activated.emit(self)

		else:
			await get_tree().create_timer(0.5).timeout
			
			$Overlay.region_rect = Rect2(_rect.position + Vector2(0, _rect.size.y), _rect.size)
			if _key_tween: _key_tween.kill()
			_key_tween = get_tree().create_tween()
			_key_tween.tween_property($Overlay, "modulate:a", 1.0, 0.3)
			
			AudioManager.play_effect(AudioManager.invalid_placement_sfx)

func _on_body_exited(body: Node2D) -> void:
	if body is Key and body.lock == self and not body._is_encrypted:
		EventManager.lock_deactivated.emit(self)
	
	if _key_tween: _key_tween.kill()
	_key_tween = get_tree().create_tween()
	_key_tween.tween_property($Overlay, "modulate:a", 0., 0.3)
