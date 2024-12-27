extends TileMapLayer

func _ready() -> void:
	for child in get_children():
		child.position = (Vector2(local_to_map(child.position)) + Vector2(0.5, 0.5)) * Vector2(tile_set.tile_size) 

func _process(delta: float) -> void:
	pass
