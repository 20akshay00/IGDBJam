extends Node2D

@onready var _tile_map: TileMapLayer = $Grid

var _filled_tile_atlas_coord = Vector2i(4, 0)
var _empty_tile_atlas_coord = Vector2i(3, 2)
var _rect: Rect2

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


func _on_reset_data_button_pressed() -> void:
	$ConfirmationDialog.show()


func _on_confirmation_dialog_confirmed() -> void:
	if FileAccess.file_exists("user://save_data_v1.json"):
		DirAccess.remove_absolute("user://save_data_v1.json")
	
	LevelManager.reset_data()
	LevelManager.reload_level()

func _on_confirmation_dialog_canceled() -> void:
	pass
