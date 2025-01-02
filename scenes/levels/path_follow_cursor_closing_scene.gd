extends PathFollow2D

var speed = 0.22
var called = false
var called2 = false
var can_continue = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if progress_ratio < 0.55 or can_continue:
		if progress_ratio < 0.99:
			progress_ratio += delta * speed
		elif not called2:
			called2 = true
			_next2()
			
	elif not called:
		called = true
		_next()

func _next() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(%HoneyPot, "scale", Vector2(1.1, 1.1), 0.2)
	await tween.finished
	AudioManager.play_effect(AudioManager.mouse_click_sfx)
	%HoneyPot.reparent(self)
	can_continue = true

func _next2() -> void:
	AudioManager.play_effect(AudioManager.mouse_click_sfx)
	var tween = create_tween()
	tween.tween_property(%HoneyPot, "scale", Vector2(1., 1.), 0.2)
	tween.tween_property(%HoneyPot, "modulate:a", 0., 1.)
	await tween.finished
	await get_tree().create_timer(1.).timeout
	LevelManager.load_level(0)
