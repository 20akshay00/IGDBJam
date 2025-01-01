extends Control

func _ready() -> void:
	EventManager.detected_on_tick.connect(_update_value)
	EventManager.tick_complete.connect(_on_tick_completed)
	Stats.stealth_points = Stats.stealth_points_max
	_set_value(0)
	
func _update_value():
	Stats.stealth_points -= 1
	_set_value(10. - Stats.stealth_points)
	AudioManager.play_effect(AudioManager.stealth_sfx)

	if Stats.stealth_points == 0:
		EventManager._on_level_lose()

func _set_value(val: int):
	$ForegroundBar.material.set_shader_parameter("value", val/10.)

func _on_tick_completed() -> void:
	get_parent().get_node("TickLabel").text = "Clock cycles: " + str(EventManager.ticks)
