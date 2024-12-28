extends Block
class_name Key

@export var lock: Lock
@export var color: Config.color_index
@export var _chain_animation_sec := 0.3
@export var _is_encrypted := false

var _chain_tween: Tween = null

func _ready() -> void:
	$Foreground.modulate = Config.colors[color]
	lock.get_node("Foreground").modulate = Config.colors[color]
	
	if _is_encrypted:
		_chain_tween = get_tree().create_tween()
		_chain_tween.tween_property($Chains, "modulate:a", 1., _chain_animation_sec)

func decrypt() -> void:
	_is_encrypted = false
	_chain_tween = get_tree().create_tween()
	_chain_tween.tween_property($Chains, "modulate:a", 0., _chain_animation_sec)
