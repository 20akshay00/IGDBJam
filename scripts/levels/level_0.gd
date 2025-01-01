extends Node2D

func _ready() -> void:
	EventManager._on_level_start()
	EventManager.level_complete.connect(_on_level_complete)
	EventManager.level_lose.connect(_on_level_lose)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		LevelManager.reload_level()

func _on_level_complete() -> void:
	for child in $Grid.get_children():
		if child is ControllableEntity:
			child.set_active(false)

	$UI/LevelEndUI.launch()

func _on_level_lose() -> void:
	for child in $Grid.get_children():
		if child is ControllableEntity:
			child.set_active(false)
	
	$UI/LevelLoseUI.launch()
