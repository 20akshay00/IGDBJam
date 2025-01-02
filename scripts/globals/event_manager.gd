extends Node

var _tick_in_progress := false

signal lock_activated(lock: Lock)
signal lock_deactivated(lock: Lock)

signal detected_on_tick()
signal tick()
signal tick_complete()

signal level_complete()
signal level_lose()

var time: int = 0
var ticks: int = 0
var is_detected := false

func _on_level_start():
	time = Time.get_ticks_msec()
	ticks = 0

func _on_level_complete():
	time = Time.get_ticks_msec() - time
	level_complete.emit()
	
	var prev_ticks = LevelManager.ticks[LevelManager.current_level]
	var prev_time = LevelManager.times[LevelManager.current_level]

	if prev_ticks != -1:
		LevelManager.ticks[LevelManager.current_level] = min(ticks, prev_ticks)
	else:
		LevelManager.ticks[LevelManager.current_level] = ticks
		
	if prev_time != -1:
		LevelManager.times[LevelManager.current_level] = min(time, prev_time)
	else:
		LevelManager.times[LevelManager.current_level] = time

func _on_level_lose():
	level_lose.emit()

func on_tick_complete():
	ticks += 1
	_tick_in_progress = false
	tick_complete.emit()

func tick_started(object: Node2D) -> void:
	_tick_in_progress = true
	tick.emit()

func reset_tick() -> void:
	_tick_in_progress = false
	ticks = 0
