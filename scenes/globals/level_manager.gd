extends Node

var current_level: int = 0
var tutorial_complete := false
var all_complete := false

var levels = [
	"res://scenes/levels/main_menu.tscn",
	# tutorial
	"res://scenes/levels/acoshey6.tscn",
	"res://scenes/levels/acoshey7.tscn",
	"res://scenes/levels/acoshey8.tscn",
	"res://scenes/levels/book3.tscn",
	"res://scenes/levels/book2.tscn",
	# easy
	"res://scenes/levels/acoshey1.tscn",
	"res://scenes/levels/book4.tscn",
	"res://scenes/levels/book1.tscn",
	"res://scenes/levels/book5.tscn",
	# med
	"res://scenes/levels/acoshey5.tscn",
	"res://scenes/levels/acoshey3.tscn",
	"res://scenes/levels/book6.tscn",
	"res://scenes/levels/book7.tscn",
	# hard
	"res://scenes/levels/acoshey2.tscn",
	"res://scenes/levels/acoshey4.tscn",
	# end
	"res://scenes/levels/last_level.tscn",
	"res://scenes/levels/closing_scene.tscn"
]

var times: Array[int] = []
var ticks: Array[int] = []
var stars: Array[int] = []

var star5: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var star4: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var star3: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var star2: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var star1: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

func _ready() -> void:
	var n = len(levels)
	times.resize(n)
	times.fill(-1)
	
	ticks.resize(n)
	ticks.fill(-1)
	
	stars.resize(n)
	stars.fill(-1)
	
	assert(len(star5) == n, "Star list must have same entries as number of levels (including start)")
	assert(len(star4) == n, "Star list must have same entries as number of levels (including start)")
	assert(len(star3) == n, "Star list must have same entries as number of levels (including start)")
	assert(len(star2) == n, "Star list must have same entries as number of levels (including start)")
	assert(len(star1) == n, "Star list must have same entries as number of levels (including start)")
	
func load_level(lvl: int):
	current_level = lvl
	if (ticks[1] != -1) and (ticks[2] != -1) and (ticks[3] != -1) and (ticks[4] != -1) and (ticks[5] != -1):
		tutorial_complete = true
	
	var flag = true
	for idx in range(17):
		if ticks[idx + 1] == -1:
			flag = false
			break
	
	if flag: all_complete = true
		
	TransitionManager.change_scene(levels[lvl])
	EventManager.reset_tick()
	AudioManager.play_music_level(lvl)
	
func load_next_level():
	load_level(current_level + 1)

func reload_level():
	TransitionManager.reload_scene()
	EventManager.reset_tick()
	AudioManager.play_music_level(current_level)

func calculate_stars(lvl_tick: int) -> int:
	var lvl = current_level
	
	if lvl_tick <= star5[lvl]:
		return 5
	elif lvl_tick <= star4[lvl]:
		return 4
	elif lvl_tick <= star3[lvl]:
		return 3
	elif lvl_tick <= star2[lvl]:
		return 2
	elif lvl_tick <= star1[lvl]:
		return 1
	else:
		return 0
