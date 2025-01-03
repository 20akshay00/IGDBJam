extends Node2D


func _ready() -> void:
	await get_tree().create_timer(1.).timeout
	%PathFollowCursor.process_mode = Node2D.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip"):
		LevelManager.load_level(0)
