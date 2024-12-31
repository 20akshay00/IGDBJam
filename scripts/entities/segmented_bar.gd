extends Control

func _ready() -> void:
	EventManager.detected_on_tick.connect(_update_value)

func _update_value():
	Stats.stealth_points -= 1
	_set_value(Stats.stealth_points)

func _set_value(val: int):
	$ForegroundBar.material.set_shader_parameter("value", val/10.)
