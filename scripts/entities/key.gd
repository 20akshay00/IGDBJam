extends Block
class_name Key

@export var lock: Lock
@export var color: Config.color_index

func _ready() -> void:
	$Foreground.modulate = Config.colors[color]
	lock.get_node("Foreground").modulate = Config.colors[color]
