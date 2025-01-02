extends Control


func _on_home_pressed() -> void:
	LevelManager.load_level(0)

func _on_retry_pressed() -> void:
	LevelManager.reload_level()

func _on_help_pressed() -> void:
	pass # Replace with function body.
