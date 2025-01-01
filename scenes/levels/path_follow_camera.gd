extends PathFollow2D

var speed = 0.5
var zoomed = false

func _ready() -> void:
	process_mode = Node2D.PROCESS_MODE_DISABLED
	
func _process(delta: float) -> void:
	if progress_ratio < 0.99:
		progress_ratio += delta * speed
	if not zoomed:
		zoomed = true
		_zoom()
	if progress_ratio > 0.8:
		LevelManager.load_level(0)
		
func _zoom() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D, "zoom", Vector2(15, 15), 3.)
	await tween.finished
