extends PathFollow2D

var speed = 0.22
var called = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	if progress_ratio < 0.99:
		progress_ratio += delta * speed
	elif not called:
		called = true
		_next()

func _next() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%Game, "scale", Vector2(1.1, 1.1), 0.2)
	await tween.finished
	AudioManager.play_effect(AudioManager.mouse_click_sfx)
	
	tween = get_tree().create_tween()
	tween.tween_property(%Bug, "scale", Vector2(1., 1.), 0.75)
	%PathFollow2D.process_mode = Node2D.PROCESS_MODE_ALWAYS
	
