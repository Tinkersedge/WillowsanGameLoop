# Player Script
extends CharacterBody2D

#@onready var interactionArea:Area2D = $Kevin/InteractionArea

#var currentInteractable = null
#
#
#func _ready() -> void:
	#interactionArea.area_entered.connect(_on_InteractionArea_entered)
	#interactionArea.area_exited.connect(_on_InteractionArea_exited)
#
#
#func _on_InteractionArea_entered(area):
	#if area.has_method("actionOn"):
		#print("Player can interact with " , area.name)
		#
#func _on_InteractionArea_exited(area):
	#print("Player has left interaction range of " , area.name)





#if Input.is_action_just_pressed("talk"):
		#var actionables = %InteractionArea.get_overlapping_areas()
		#if actionables.size() > 0:
			#actionables[0].action()
			#return
