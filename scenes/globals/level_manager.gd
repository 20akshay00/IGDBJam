extends Node

var current_level: int = 0

var levels = [
	preload("res://scenes/levels/main_menu.tscn"),
	preload("res://scenes/levels/acoshey1.tscn"),
	preload("res://scenes/levels/acoshey2.tscn"),
	preload("res://scenes/levels/acoshey3.tscn"),
	preload("res://scenes/levels/acoshey4.tscn"),
	preload("res://scenes/levels/acoshey5.tscn"),
	preload("res://scenes/levels/book1.tscn"),
	preload("res://scenes/levels/book2.tscn"),
	preload("res://scenes/levels/book3.tscn"),
	preload("res://scenes/levels/book4.tscn"),
	preload("res://scenes/levels/book5.tscn"),
	preload("res://scenes/levels/book6.tscn"),
]

var times: Array[int] = []
var ticks: Array[int] = []

var tick_targets: Array[int] = [-1, 23, 52, 53, 582, 83, 32, -1]

func _ready() -> void:
	var n = len(levels)
	times.resize(n)
	times.fill(-1)
	
	ticks.resize(n)
	ticks.fill(-1)
	
func load_level(lvl: int):
	current_level = lvl

	TransitionManager.change_scene(levels[lvl])
	EventManager.reset_tick()
	AudioManager.play_music_level()
	
func load_next_level():
	load_level(current_level + 1)

func reload_level():
	TransitionManager.reload_scene()
	EventManager.reset_tick()
	AudioManager.play_music_level()
