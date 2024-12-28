extends CanvasLayer

@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	$ColorRect.modulate.a = 0.

func _change_scene(target: String) -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	animation_player.play_backwards("fade")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
