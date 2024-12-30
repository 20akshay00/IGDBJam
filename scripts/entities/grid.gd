extends TileMapLayer

var grid: Dictionary = {}

var num_entities: int
var num_entities_completed_move: int

func _ready() -> void:
	for cell in get_used_cells():
		grid[cell] = get_cell_tile_data(cell).get_custom_data("Walkable")

	for child in get_children():
		child.position = (Vector2(local_to_map(child.position)) + Vector2(0.5, 0.5)) * Vector2(tile_set.tile_size) 
		if child is not Lock: grid[local_to_map(child.position)] = false
		if child is ControllableEntity: 
			num_entities += 1
			child.move_completed.connect(_on_move_completed)

func is_empty(position: Vector2) -> bool:
	var cell = local_to_map(position)
	
	if grid[cell]:
		grid[cell] = false
		return true
	else:
		return false

func update_grid(from: Vector2, to: Vector2) -> void:
	remove_occupation(from)
	add_occupation(to)

func remove_occupation(at: Vector2) -> void:
	grid[local_to_map(at)] = true

func add_occupation(at: Vector2) -> void:
	grid[local_to_map(at)] = false

func _on_move_completed() -> void:
	num_entities_completed_move += 1

	if num_entities_completed_move == num_entities - 1:
		EventManager.on_tick_complete()
		num_entities_completed_move = 0
