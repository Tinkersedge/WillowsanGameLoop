extends Node2D

var playerNearPlants: bool = false
var plantGameStarted: bool = false

func action():
	showHint()

func stopAction():
	hideHint()

func showHint():
	playerNearPlants = true
	%Hint.show()

func hideHint():
	playerNearPlants = false
	%Hint.hide()


func _process(_delta: float) -> void:
	if playerNearPlants and Input.is_action_just_pressed("talk"):
		print("Time to play the plant game")
		PopUps.showMe("PlantGame", null)
