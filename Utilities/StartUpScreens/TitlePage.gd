extends Node2D

func _ready() -> void:
	Global.currentScene = "title"
	
func _on_start_game_pressed() -> void:
	print("Button pressed")
	Global.moveOn()
