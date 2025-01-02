extends CanvasLayer

@onready var animation_player := $AnimationPlayer
var current_scene = null

func _ready() -> void:
	$ColorRect.modulate.a = 0.
	current_scene = get_tree().root.get_node("MainMenu")

func change_scene(target: String) -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	#_transition_to_scene(target)
	animation_player.play_backwards("fade")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func reload_scene() -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play_backwards("fade")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _transition_to_scene(scene: PackedScene) -> void:
	var instance := scene.instantiate()
	get_tree().root.add_child(instance)
	if current_scene: get_tree().root.remove_child(current_scene)
	current_scene = instance
	
