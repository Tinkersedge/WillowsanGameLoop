## PlantGame.gd
extends CanvasLayer
class_name PlantGameBase

# base garden game
const plantBalcony = preload("res://LanguageGames/VocabPlants/plant_balcony.tscn")
const seedPacket = preload("res://LanguageGames/VocabPlants/SeedPacket.tscn")

var gamePopUp = false

var plantsFilled = false
var seedsFilled = false
var planting = false
var currentPlant
var currentSeed


enum pgs { # plantGameState
	START,
	WARNING,
	PLANTORTEND,
	CHOOSEPLANT,
	FIRSTPLANT, 
	PICKPLANT, 
	TENDPLANT,
	POPPEDUP,
	PICKSEED,
	PLANTSEED,
	CLOSEME
	}

@onready var gameState = pgs.START
@onready var gardenMgr = %GardenMgr
@onready var tendGameMgr = %TendingPlant
@onready var whatSeedsHave:Array = gardenMgr.seedsAvailable

func start() -> void:
	gardenMgr.changeState.connect(onStateChanged)
	print("initializing gardenMgr...")
	gardenMgr.initialize()


func initRestart():
	print("initializing gardenMgr...")
	gardenMgr.initialize()



func onStateChanged(newState):
	# hide all screens and change the state
	print(newState)
	gameState = newState
	print("current state is now " , gameState)
	match gameState:
		"START":
			pass
		"WARNING":
			$Warning.show()
		"PLANTORTEND":
			$PoT.show()
		"CHOOSEPLANT":
			if gardenMgr.plantsAvailable.size() > 1:
				onStateChanged("PICKPLANT")
			else:
				onStateChanged("TENDPLANT")
		"PICKPLANT":
			$PickPlant.show()
			fillPlants()
		"TENDPLANT":
			print("Before going ", currentSeed, currentPlant)
			$TendPlant.show()
			tendingPlantInit()
			tendGameMgr.startTending()
		"POPPEDUP":
			pass
		"FIRSTPLANT":
			pass
		"PICKSEED":
			$PickSeed.show()
			fillSeeds()
		"PLANTSEED":
			$PlantSeed.show()
			plantingSeed()
		"CLOSEME":
			get_tree().paused = false
			hide()
	
# *************************************************************
#*****************************   PICK PLANT *************
# *******************************************************
func fillPlants():
	$PoT.hide()
	if plantsFilled == true:
		pass
	else:
		plantsFilled = true
		# Only have 5 plants, need another layer
		for plant in gardenMgr.plantsAvailable.size():
			print("Plant is ", gardenMgr.plantsAvailable[plant])
			var filledPlant = plantBalcony.instantiate()
			filledPlant.get_node("Plant1").connect("pressed", plantPressed.bind(gardenMgr.plantsAvailable[plant]))
			print("what is the currentplant ", gardenMgr.plantsAvailable[plant])
			%PlantShelf1.add_child(filledPlant)

func plantPressed(plantName: String) -> void:
	print("Inside PlantPressed, plant name is ", plantName)
	currentPlant = plantName
	print("PLant Pressed - Before going ", currentSeed, currentPlant)
	$PickPlant.hide()
	onStateChanged("TENDPLANT")
	

# *************************************************************
#*****************************   PICK Seed *************
# *******************************************************
func seedPressed(seedName:String) -> void:
	$PickSeed.hide()
	print("Plant Seed is pressed ", currentSeed)
	onStateChanged("PLANTSEED")
	currentSeed = seedName



func fillSeeds():
	$Pot.hide()
	if seedsFilled == true:
		pass
	else:
		seedsFilled = true
		for i in whatSeedsHave.size():
			print("Seed is ", whatSeedsHave[i])
			var filledSeed = seedPacket.instantiate()
			filledSeed.get_node("SeedButton").connect("pressed", seedPressed.bind(whatSeedsHave[i]["name"]))
			%SeedGrid.add_child(filledSeed)

func plantingSeed():
	# change from seed to currentPlant, add to plantsAvailable
	# wehn button pressed, start tending this plant
	$PickSeed.hide()
	if planting != true:
		planting = true
		$PlantSeed/StartPlantButton.connect("pressed", seedPlanted)

func seedPlanted():
	$PlantSeed.hide()
	currentPlant = currentSeed.replace("seeds", "plant")
	gardenMgr.plantsAvailable.append(currentPlant)
	print(gardenMgr.plantsAvailable)
	onStateChanged("TENDPLANT")

func plantSeeds() -> void:
	$PoT.hide()
	# if > one seed in inventory, pick seed, only 1 - plant seed
	print(whatSeedsHave.size())
	if whatSeedsHave.size() > 1:
		onStateChanged("PICKSEED")
	else:
		print(whatSeedsHave[0])
		seedPressed(whatSeedsHave[0])
		onStateChanged("PLANTSEED")
	
func tendGarden() -> void:
	$PoT.hide()
	# if >1 plant, choosePlant, if only 1, startTending
	onStateChanged("CHOOSEPLANT")

# *************************************************************
#*****************************   TENDING PLANTS GAME *************
# *******************************************************

# Code is held inside TendingPlant node
func tendingPlantInit():
	
	tendGameMgr.gamePopUp = gamePopUp
	tendGameMgr.currentSeed = currentSeed
	tendGameMgr.currentPlant = currentPlant
	print("initializing tending plant......")

func timeToGo():
	hide()


func _on_plant_me_pressed() -> void:
	pass # Replace with function body.
