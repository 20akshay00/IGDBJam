extends Node2D
@export var tilemap: TileMapLayer

func _draw() -> void:
	for cell in tilemap.grid:
		if tilemap.grid[cell]:
			draw_circle(Vector2(cell * tilemap.tile_set.tile_size) + 0.5 * tilemap.tile_set.tile_size, 5, Color.RED, true)
	
func _process(delta: float) -> void:
	queue_redraw()
