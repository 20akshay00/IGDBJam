extends Node2D

func _ready() -> void:
	for child in $Grid.get_children():
		if child is CarrierBug:
			if child.name != "CarrierBug":
				child.set_active(false)
