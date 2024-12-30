extends Node

var _tick_in_progress := false

signal lock_activated(lock: Lock)
signal lock_deactivated(lock: Lock)

signal tick()
var ticks: int = 0

func on_tick_complete():
	ticks += 1
	_tick_in_progress = false

func tick_started(object: Node2D) -> void:
	_tick_in_progress = true
	tick.emit()
