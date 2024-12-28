extends Area2D
class_name Lock

func _on_body_entered(body: Node2D) -> void:
	if body is Key and body.lock == self and not body._is_encrypted:
		EventManager.lock_activated.emit(self)
		body.get_node("Background").modulate = Config.SUCCESS_COLOR
		
func _on_body_exited(body: Node2D) -> void:
	if body is Key and body.lock == self and not body._is_encrypted:
		EventManager.lock_deactivated.emit(self)
		body.get_node("Background").modulate = Config.DEFAULT_COLOR
