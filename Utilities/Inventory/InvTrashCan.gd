extends Area2D



func _ready() -> void:
	$TossZone.disabled = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		#print("you hit the trashcan")
		Signals.thrownAway.emit()
