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
	"res://scenes/levels/closing_scene.tscn",
	
	# start
	"res://scenes/levels/opening_scene.tscn"
	]

var times: Array[int] = []
var ticks: Array[int] = []
var stars: Array[int] = []

var star1: Array[int] = [-1, 21, 50, 40, 100, 90, 100, 100, 130, 300, 210, 280, 150, 110, 310, 750, -1, -1, -1]
var star2: Array[int] = [-1, 20, 45, 35, 93, 75, 90, 95, 125, 280, 200, 220, 143, 100, 250, 600, -1, -1, -1]
var star3: Array[int] = [-1, 19, 42, 31, 89, 67, 80, 90, 110, 270, 190, 205, 138, 95, 210, 500, -1, -1, -1]
var star4: Array[int] = [-1, 18, 40, 28, 86, 62, 70, 84, 105, 258, 180, 190, 130, 90, 205, 480, -1, -1, -1]
var star5: Array[int] = [-1, 17, 38, 25, 82, 59, 62, 71, 90, 246, 168, 180, 126, 88, 190, 430, -1, -1, -1]

func _ready() -> void:
	var n = len(levels)
		
	if FileAccess.file_exists("user://save_data_v1.json"):
		FileAccess.open("user://save_data_v1.json", FileAccess.READ)
		var json := JSON.new()
		var error := json.parse(FileAccess.get_file_as_string("user://save_data_v1.json"))
		if error == OK:
			var data = json.data
			
			times.assign(data["times"])
			ticks.assign(data["ticks"])
			stars.assign(data["stars"])
		else:
			print("Unable to read save data!")
			
			times.resize(n)
			times.fill(-1)
			
			ticks.resize(n)
			ticks.fill(-1)
			
			stars.resize(n)
			stars.fill(-1)
	else:
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

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_data()

func load_level(lvl: int):
	_save_data()
	current_level = lvl
	if (ticks[1] != -1) and (ticks[2] != -1) and (ticks[3] != -1) and (ticks[4] != -1) and (ticks[5] != -1):
		tutorial_complete = true
	
	var flag = true
	for idx in range(15):
		if ticks[idx + 1] == -1:
			flag = false
			break
		
	if flag: all_complete = true
		
	TransitionManager.change_scene(levels[lvl])
	EventManager.reset_tick()
	AudioManager.play_music_level(lvl)
	
func load_next_level():
	if current_level == 15: 
		load_level(0)
	else:
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

func _save_data() -> void:
	var save_data := {"ticks": ticks, "times": times, "stars": stars}
	var save_file := FileAccess.open("user://save_data_v1.json", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))

func reset_data() -> void:
	var n := len(levels)
	times.resize(n)
	times.fill(-1)
	
	ticks.resize(n)
	ticks.fill(-1)
	
	stars.resize(n)
	stars.fill(-1)
