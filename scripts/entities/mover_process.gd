extends ControllableEntity
class_name MoverProcess

@onready var timer := $Timer

var count := 3
var dir := -1

func set_active_hook(val: bool) -> void:
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
			sprite.scale.x = dir
	
		_move(Vector2(dir, 0))
