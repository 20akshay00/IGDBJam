extends Control

var tween: Tween = null

func _ready() -> void:
	modulate.a = 0
	$StarSlots.modulate.a = 0
	$LevelLabel.modulate.a = 0
	$VBoxContainer/ClockCycleLabel.modulate.a = 0
	$VBoxContainer/TimeLabel.modulate.a = 0 
	$Buttons.modulate.a = 0

	for star in $Stars.get_children():
		star.modulate.a = 0

func launch():
	show()
	_launch(LevelManager.current_level, EventManager.ticks, EventManager.time)
	
func _launch(lvl: int, clock: int, time: int) -> void:
	_set_level_text(lvl)
	_set_clock_cycle(clock)
	_set_time(time)
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1., 2.)
	tween.tween_property($LevelLabel, "modulate:a", 1., 1.5)
	tween.tween_property($VBoxContainer/ClockCycleLabel, "modulate:a", 1., 1.5)
	tween.tween_property($VBoxContainer/TimeLabel, "modulate:a", 1., 1.5)
	tween.tween_property($StarSlots, "modulate:a", 1., 1.)
	await tween.finished
	_set_stars(5)

func _set_level_text(lvl: int) -> void:
	$LevelLabel.text = "Level " + str(lvl)

func _set_clock_cycle(cycles: int):
	$VBoxContainer/ClockCycleLabel.text = "Clock cycles utilized: " + str(cycles)
	
func _set_time(time: int):
	$VBoxContainer/TimeLabel.text = "Real-time elapsed: " + str((time / 60) % 60) + " mins, " + str(time % 60)

func _set_stars(stars: int) -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	
	for i in min(5, stars):
		tween.tween_property($Stars.get_child(i), "modulate:a", 1., 0.1)
		
	await tween.finished
	_activate_buttons()

func _activate_buttons() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($Buttons, "modulate:a", 1., 0.1)


func _on_retry_pressed() -> void:
	LevelManager.reload_level()

func _on_home_pressed() -> void:
	LevelManager.load_level(0)

func _on_next_pressed() -> void:
	LevelManager.load_next_level()
