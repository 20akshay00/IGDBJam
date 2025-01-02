extends TextureRect

var tween: Tween = null
var fade_secs: float = 0.2

func set_stats(time: int, ticks: int, stars: int, lvl: int) -> void:
	if not modulate.a == 0: 
		_hide()
		await tween.finished
		
	_set_stats(time, ticks, stars, lvl)
	_show()

func _set_stats(time: int, ticks: int, stars: int, lvl: int) -> void:
	if stars != -1:
		$VBoxContainer/Stars.text = "Stars: " + str(stars) + "/5"
	else:
		$VBoxContainer/Stars.text = "Stars: ???" 
	
	if ticks != -1:
		$VBoxContainer/ClockCycles.text = "Clock cycles: " + str(ticks)
	else:
		$VBoxContainer/ClockCycles.text = "Clock cycles: ???"

	if time != -1:
		$VBoxContainer/RealTime.text = "Real-time: " + str(time)
	else:
		$VBoxContainer/RealTime.text = "Real-time: ???"
	
	$Level.text = "Level " + str(lvl)

func _show():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1., fade_secs)
	
func _hide():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0., fade_secs)
