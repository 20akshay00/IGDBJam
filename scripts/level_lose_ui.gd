extends Control

var tween: Tween = null
var tween2: Tween = null

func _ready() -> void:
	modulate.a = 0
	$LevelLabel.modulate.a = 0
	$Buttons.modulate.a = 0
	$TextLabel.modulate.a = 0

func launch():
	show()
	_launch(LevelManager.current_level, EventManager.ticks, EventManager.time)
	
func _launch(lvl: int, clock: int, time: int) -> void:
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1., 2.)
	tween.tween_property($LevelLabel, "modulate:a", 1., 1.5)
	tween.tween_property($TextLabel, "modulate:a", 1., 2.)
	await tween.finished
	
	if tween2: tween2.kill()
	tween2 = get_tree().create_tween()
	tween2.set_loops()
	tween2.tween_property($TextLabel, "modulate:a", 0.3, 1.)
	tween2.tween_property($TextLabel, "modulate:a", 1., 1.)

	_activate_buttons()

func _on_retry_pressed() -> void:
	LevelManager.reload_level()
	if tween2: tween2.kill()

func _on_home_pressed() -> void:
	LevelManager.load_level(0)
	if tween2: tween2.kill()

func _activate_buttons() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($Buttons, "modulate:a", 1., 1.)
