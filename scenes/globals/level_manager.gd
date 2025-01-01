extends Node

var current_level: int = 0

var levels = [
	preload("res://scenes/levels/level0.tscn")
	#"level1": preload("res://levels/level_1.tscn"),
	#"level2": preload("res://levels/level_2.tscn"),
	#"level3": preload("res://levels/level_3.tscn"),
	#"level4": preload("res://levels/level_4.tscn"),
	#"level5": preload("res://levels/level_5.tscn"),
	#"level6": preload("res://levels/level_6.tscn"),
	#"end": preload("res://levels/game_end.tscn"),
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
