extends Area2D
class_name Gate

@export var locks: Array[Lock]
var unlock_indices: Array[int] = []

func _ready() -> void:
	EventManager.lock_activated.connect(_on_lock_activated)
	EventManager.lock_deactivated.connect(_on_lock_deactivated)

func _on_lock_activated(lock: Lock):
	var idx = locks.find(lock, 0)
	if idx >= 0: 
		unlock_indices.push_back(idx) 
	
	_update_status()

func _on_lock_deactivated(lock: Lock):
	var idx = locks.find(lock, 0)
	if idx >= 0: 
		unlock_indices.erase(idx)

	_update_status()

func _update_status() -> void:
	if len(locks) == len(unlock_indices):
		$Sprite2D.hide()
	else:
		$Sprite2D.show()
