extends PathFollow2D

var speed = 0.4
var can_move = true

var can_shrink = true

func _ready() -> void:
	process_mode = Node2D.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if progress_ratio < 0.99 and can_move:
		progress_ratio += delta * speed

	if progress_ratio > 0.7:
		can_shrink = false
		_shrink()
		
func _shrink():
	var tween = get_tree().create_tween()
	tween.tween_property($Bug, "scale", Vector2(0, 0), 2.)
	tween.tween_callback(func(): return)
	await tween.finished
	%PathFollowCamera.process_mode = Node.PROCESS_MODE_ALWAYS
