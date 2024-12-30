extends Area2D
class_name Portal

@export var UI: CanvasLayer

var tween: Tween = null

func _on_body_entered(body: Node2D) -> void:
	if body is not CarrierBug:
		if tween: tween.kill()
		tween = get_tree().create_tween()
		tween.set_loops()
		tween.tween_property(UI.get_node("WrongBotLabel"), "modulate:a", 1., 0.5)
		tween.tween_property(UI.get_node("WrongBotLabel"), "modulate:a", 0.3, 0.5)
		AudioManager.play_effect(AudioManager.invalid_placement_sfx)
	elif body is CarrierBug and EventManager.is_detected:
		if tween: tween.kill()
		tween = get_tree().create_tween()
		tween.set_loops()
		tween.tween_property(UI.get_node("SecurityLabel"), "modulate:a", 1., 0.5)
		tween.tween_property(UI.get_node("SecurityLabel"), "modulate:a", 0.3, 0.5)
		AudioManager.play_effect(AudioManager.invalid_placement_sfx)

func _on_body_exited(body: Node2D) -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(UI.get_node("WrongBotLabel"), "modulate:a", 0., 0.5)
	tween.tween_property(UI.get_node("SecurityLabel"), "modulate:a", 0., 0.5)
