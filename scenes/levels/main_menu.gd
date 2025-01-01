extends Control

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Title, "modulate:a", 1., 2.)
	await tween.finished
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property($Title, "rotation_degrees", -6, 1.)
	tween.tween_property($Title, "rotation_degrees", 4, 2.)
