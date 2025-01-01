extends TileMapLayer

var grid: Dictionary = {}

var num_entities: int
var num_entities_completed_move: int

var astargrid := AStarGrid2D.new()

func _ready() -> void:
	EventManager.reset_tick()
	for cell in get_used_cells():
		grid[cell] = get_cell_tile_data(cell).get_custom_data("Walkable")

	for child in get_children():
		child.position = (Vector2(local_to_map(child.position)) + Vector2(0.5, 0.5)) * Vector2(tile_set.tile_size) 
		if (child is not Lock) and (child is not Portal) and (child is not Hash): grid[local_to_map(child.position)] = false
		if child is ControllableEntity: 
			num_entities += 1
			child.move_completed.connect(_on_move_completed)

	_setup_astar()
	
func _setup_astar() -> void:
	astargrid.region = get_used_rect()
	astargrid.cell_size = Vector2i(64, 64)
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	astargrid.update()
	for cell in get_used_cells():
		astargrid.set_point_solid(cell, not grid[cell])

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

func get_next_dir_to(from: Vector2, to: Vector2):
	_setup_astar()
	var pos1 := local_to_map(from)
	var pos2 := local_to_map(to)
	
	var path := astargrid.get_id_path(pos1, pos2, false)
	
	if path: 
		return Vector2(path[1] - pos1)
	else: 
		if (pos1.x == pos2.x) or (pos1.y == pos2.y):
			return pos2 - pos1
		else:
			return Vector2(1, 0)
