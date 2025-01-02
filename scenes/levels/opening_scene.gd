extends Node2D


func _ready() -> void:
	await get_tree().create_timer(1.).timeout
	%PathFollowCursor.process_mode = Node2D.PROCESS_MODE_ALWAYS
