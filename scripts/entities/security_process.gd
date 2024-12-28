extends ControllableEntity
class_name SecurityProcess

@onready var timer := $Timer

var count := 3
var dir := -1

func set_active_hook(val: bool) -> void:
	_current_direction = Vector2(cos(sprite.rotation), sin(sprite.rotation))
	if val: 
		timer.stop()
	else:
		timer.start()

func _on_timer_timeout() -> void:
	if not raycast.is_colliding():
		count += 1
		if count > 3: 
			count = 0
			dir *= -1
			sprite.rotation = dir * PI/2
	
		_move(Vector2(dir, 0))
