extends Area2D
class_name Actionable

@export var myOwner: Node

func _ready() -> void:
	area_entered.connect(_on_Actionable_area_entered)
	area_exited.connect(_on_Actionable_area_exited)

func _on_Actionable_area_entered(area):
	if area.is_in_group("PlayerZone") and myOwner:
		#print("player's here")
		myOwner.action()

func _on_Actionable_area_exited(area):
	if area.is_in_group("PlayerZone") and myOwner:
		#print("player's gone")
		myOwner.stopAction()
	
