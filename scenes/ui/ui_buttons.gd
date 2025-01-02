extends Control

var tween: Tween = null
@onready var help = $HelpScreen

func _ready() -> void:
	$HelpScreen/CloseButton.pressed.connect(_on_button_pressed)
	help.hide()
	help.modulate.a = 0
	help.z_index = 2

func _on_home_pressed() -> void:
	LevelManager.load_level(0)

func _on_retry_pressed() -> void:
	LevelManager.reload_level()

func _on_help_pressed() -> void:
	help.show()
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(help, "modulate:a", 1., 0.5)
	await tween.finished

func _on_button_pressed() -> void:
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(help, "modulate:a", 0., 0.5)
	await tween.finished
	help.hide()
