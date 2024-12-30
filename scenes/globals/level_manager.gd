extends Node

var levels = {
	"start": preload("res://scenes/levels/level0.tscn"),
	#"level1": preload("res://levels/level_1.tscn"),
	#"level2": preload("res://levels/level_2.tscn"),
	#"level3": preload("res://levels/level_3.tscn"),
	#"level4": preload("res://levels/level_4.tscn"),
	#"level5": preload("res://levels/level_5.tscn"),
	#"level6": preload("res://levels/level_6.tscn"),
	#"end": preload("res://levels/game_end.tscn"),
}

func load_level(name):
	TransitionManager.change_scene(levels[name])
	EventManager.reset_tick()
	
func reload_level():
	TransitionManager.reload_scene()
	EventManager.reset_tick()
