extends Block
class_name Key

@export var lock: Lock
@export var color: Config.color_index
@export var _chain_animation_sec := 0.3
@export var _is_encrypted := false

var _chain_tween: Tween = null

func _ready() -> void:
	var rect = $Sprite.region_rect
	$Sprite.region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)

	rect = $ChainedSprite.region_rect
	$ChainedSprite.region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)
	
	rect = lock.get_node("Sprite").region_rect
	lock.get_node("Sprite").region_rect = Rect2(rect.position + Vector2(color * rect.size.x, 0), rect.size)
	
	if _is_encrypted:
		_chain_tween = get_tree().create_tween()
		_chain_tween.set_parallel()
		_chain_tween.tween_property($Sprite, "modulate:a", 0., _chain_animation_sec)
		_chain_tween.tween_property($ChainedSprite, "modulate:a", 1., _chain_animation_sec)

func decrypt() -> void:
	_is_encrypted = false
	_chain_tween = get_tree().create_tween()
	_chain_tween.set_parallel()
	_chain_tween.tween_property($Sprite, "modulate:a", 1., _chain_animation_sec)
	_chain_tween.tween_property($ChainedSprite, "modulate:a", 0., _chain_animation_sec)
	lock._on_body_entered(self)
