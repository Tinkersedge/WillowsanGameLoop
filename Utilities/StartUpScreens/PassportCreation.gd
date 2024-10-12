extends Node2D

func _ready() -> void:
	Global.currentScene = "passport"



func _on_next_pressed() -> void:
	Global.moveOn()
