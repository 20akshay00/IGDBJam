extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		%PathFollowCursor.process_mode = Node2D.PROCESS_MODE_ALWAYS
