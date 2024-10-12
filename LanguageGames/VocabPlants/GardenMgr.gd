# GardenMgr.gd
extends Node


#script in charge of setting up the garden and stats
var plantsFilled = false
var seedsFilled = false
var seedsAvailable:Array = ["seeds_months"]
#var plantsAvailable:Array = []
var plantsAvailable:Array = ["plant_days", "plant_colors"]

signal changeState(newState)

func initialize():
	for screens in get_tree().get_nodes_in_group("PlantScenes"):
		screens.hide()
	plantsFilled = false
	if seedsAvailable == [] and plantsAvailable == []:
		changeState.emit("WARNING")
	# if seeds and plants
	elif seedsAvailable != [] and plantsAvailable != []:
		print("PLANT OR TEND")
		changeState.emit("PLANTORTEND")
	# if plants and no seeds
	elif seedsAvailable == [] and plantsAvailable != []:
		print("CHOOSE PLANT")
		changeState.emit("CHOOSEPLANT")
	# if seeds and no plants
	elif seedsAvailable != [] and plantsAvailable == []:
		print("FIRST PLANT")
		changeState.emit("FIRSTPLANT")
