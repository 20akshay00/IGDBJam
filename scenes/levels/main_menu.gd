extends Node2D

@onready var _tile_map: TileMapLayer = $Grid

var _filled_tile_atlas_coord = Vector2i(4, 0)
var _empty_tile_atlas_coord = Vector2i(3, 2)
var _rect: Rect2

var keys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

func _ready() -> void:
	if not LevelManager.tutorial_complete:
		_tile_map.set_cell(Vector2(10, 7), 0, _empty_tile_atlas_coord, 0)
	else:
		_tile_map.set_cell(Vector2(10, 7), 0, _filled_tile_atlas_coord, 0)
	
	if not LevelManager.all_complete:
		_tile_map.set_cell(Vector2(2, 6), 0, _empty_tile_atlas_coord, 0)
	else:
		_tile_map.set_cell(Vector2(2, 5), 0, _filled_tile_atlas_coord, 0)
	
	for child in $Grid.get_children():
		if child is LevelSelect:
			if LevelManager.ticks[child.level_idx] > -1:
				_rect = child.get_node("Sprite").region_rect
				child.get_node("Sprite").region_rect = Rect2(_rect.position + Vector2(_rect.size.x, 0), _rect.size)
				_rect = child.get_node("Overlay").region_rect
				child.get_node("Overlay").region_rect = Rect2(_rect.position + Vector2(0, _rect.size.y), _rect.size)

	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($QLabel, "modulate:a", 0.3, 1.)
	tween.tween_property($QLabel, "modulate:a", 1., 1.)

func _input(event: InputEvent) -> void:
	for idx in len(keys):
		if Input.is_action_pressed(keys[idx]):
			LevelManager.load_level(idx)
