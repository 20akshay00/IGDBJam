extends Node

var current_level: int = 0
var tutorial_complete := false

var levels = [
	"res://scenes/levels/main_menu.tscn",
	"res://scenes/levels/acoshey1.tscn",
	"res://scenes/levels/acoshey2.tscn",
	"res://scenes/levels/acoshey3.tscn",
	"res://scenes/levels/acoshey4.tscn",
	"res://scenes/levels/acoshey5.tscn",
	"res://scenes/levels/book1.tscn",
	"res://scenes/levels/book2.tscn",
	"res://scenes/levels/book3.tscn",
	"res://scenes/levels/book4.tscn",
	"res://scenes/levels/book5.tscn",
	"res://scenes/levels/book6.tscn",
	"res://scenes/levels/book7.tscn"
]

var times: Array[int] = []
var ticks: Array[int] = []

var tick_targets: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1]

func _ready() -> void:
	var n = len(levels)
	times.resize(n)
	times.fill(-1)
	
	ticks.resize(n)
	ticks.fill(-1)
	
func load_level(lvl: int):
	current_level = lvl
	if (ticks[1] != -1) and (ticks[2] != -1) and (ticks[3] != -1):
		tutorial_complete = true
	
	TransitionManager.change_scene(levels[lvl])
	EventManager.reset_tick()
	AudioManager.play_music_level()
	
func load_next_level():
	load_level(current_level + 1)

func reload_level():
	TransitionManager.reload_scene()
	EventManager.reset_tick()
	AudioManager.play_music_level()
