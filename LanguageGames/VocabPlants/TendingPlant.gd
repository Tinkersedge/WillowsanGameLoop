# TendingPlant.gd
extends Node


enum plantStages {
	PLANTED, # seed planted, introduce all words
	SEEDLING, # 1/2 plants correct 4x
	MEDIUM, # 3/4 plants correct 6x (new pot)
	LARGE, # all plants correct 8x
	BLOOMED # all plants correct 10x (move out)
}


# Script of the actually tending game
var currentPlant
var currentSeed

var gamePopUp
var plantStage
var currentGameArray: Array
var gameArrayStart: Array
var numQuestions = 0
var correctAnswers = 0
var prob:int = 0
var prevNum = 800
var lastNum = 0
var correctAnswer: String

@onready var mainGame = $".."



# After plant is picked, seeds are ready, start Game
func startTending():
	print("starting tending plant.......")
	for button in get_tree().get_nodes_in_group("AnswerButtonsSimple"):
		button.connect("pressed",Callable(self, "checkAnswer").bind(button))
	print("current seed " , mainGame.currentSeed , " currentPlant ", mainGame.currentPlant)
	currentSeed = currentPlant.replace("plant", "seeds")
	#print("current seed is " , currentSeed)
	if gamePopUp == false:
		gamePopUp = true
		mainGame.onStateChanged("POPPEDUP")
		%TendPlant.show()
		var stageNeeded:int = PlantData.assessPlant(currentSeed)
		print("stage needed is " , stageNeeded)
		var stageMap = {
			0: plantStages.PLANTED,
			1: plantStages.SEEDLING,
			2: plantStages.MEDIUM,
			3: plantStages.LARGE,
			4: plantStages.BLOOMED
		}
		plantStage = stageMap.get(stageNeeded, null)

		showGame()

func showGame():
	match plantStage:
		0:
			startSimpleGame()
		1:
			startSimpleGame()
		2:
			startTypingGame()
		3:
			startTypingGame()
		4:
			pass # This plant is fully grown, do you want to practice anyway?
		_:
			print("something went wrong.")


func startSimpleGame():
	currentGameArray = []
	currentGameArray = PlantData.getCurrentSeeds()
	print("starting game, currentGameArray ", currentGameArray.size())
	currentGameArray.shuffle()
	gameArrayStart = currentGameArray.duplicate()
	
	numQuestions = currentGameArray.size()
	%WaterUp.max_value = numQuestions
	fillTextSimple()
	
	# create fillText() to fill the answers
	# create checkAnswer() to check the answer
	# when session is over, need to check stage and stats and save them to PlantData

func startTypingGame():
	pass
	# create fillText() to fill all the options for spelling choices
	# create checkAnswer() to check the answer
	# when session is over, need to check stage and stats and save them to PlantData

func fillTextSimple():
	prob = pickRndProb()
	#print("current prob is ", prob , " currentGamesize ", currentGameArray.size())
	# Determine the language order
	var questionLang = 0 # English Word, 1, is Korean Word
	var answerLang = 1
	var langOrder = currentGameArray[prob][9]
	if langOrder == "K2E":
		questionLang = 1
		answerLang = 0
	elif langOrder == "E2K":
		questionLang = 0
		answerLang = 1
		
	# Set the question text
	$%Question.text = currentGameArray[prob][questionLang]
	
	# Initialize the answer array
	print("adding answers...")
	var answers: Array = []
	correctAnswer = currentGameArray[prob][answerLang]
	answers.append(currentGameArray[prob][answerLang]) # add correct answer into choices
	
	
	# fill in remaining 4 spots with random answers from this array
	while answers.size() < 5:
		var randomEntry = gameArrayStart.pick_random()
		#print("randomEntry is ", randomEntry)
		var randomAnswer = randomEntry[answerLang]
		if randomAnswer not in answers:
			answers.append(randomAnswer)
	
	answers.shuffle()
	%Ans1/Ans.text = answers[0]
	%Ans2/Ans.text = answers[1]
	%Ans3/Ans.text = answers[2]
	%Ans4/Ans.text = answers[3]
	%Ans5/Ans.text = answers[4]
	
	#print("your answers are ", answers)
	
	

func checkAnswer(button):
	print("inside checkAnswer, currentGamesize is ", currentGameArray.size())
	var currentQuestion = currentGameArray[prob]
	
	
	if button.get_node("Ans").text == correctAnswer:
		pass # show watering animation, show picture
		correctAnswers += 1
		#print(correctAnswers)
		PlantData.updateDict(currentGameArray[prob][0], "correct")
		fillFlower()
		clearText()
		currentGameArray.erase(currentQuestion)
		if correctAnswers < numQuestions:
			fillTextSimple()
		else:
			print("you have finished tending this plant")
			get_tree().paused = false
			resetPlantGame()
			mainGame.timeToGo()
			
	else:
		pass # make a sound, add question back to array
		print("you got the answer wrong")
		PlantData.updateDict(currentGameArray[prob][0], "wrong")
		var randomPosition = randi()% currentGameArray.size()
		currentGameArray.insert(randomPosition, currentQuestion)
		
		currentGameArray.erase(currentQuestion)
		#prob += 1
		fillTextSimple()
	
	
	

func pickRndProb():
	
	if currentGameArray.size() == 0:
		return null # No Questions Left
	
	prob = randi() % currentGameArray.size()
	print("current prob is ", prob , " / ", currentGameArray.size())
	return prob


func fillFlower():
	if numQuestions == 0:
		return
	
	var progress = float(correctAnswers)/float(numQuestions) * $%WaterUp.max_value
	$%WaterUp.value = progress

func clearText():
	$%Question.text = ""
	$%Ans1/Ans.text = ""
	$%Ans2/Ans.text = ""
	$%Ans3/Ans.text = ""
	$%Ans4/Ans.text = ""
	$%Ans5/Ans.text = ""

func resetPlantGame():
	#PlantData.resetGame()
	currentPlant = ""
	currentGameArray.clear()
	gameArrayStart.clear()
	numQuestions = 0
	correctAnswers = 0
	prob = 0
	prevNum = 800
	lastNum = 0
	correctAnswer = ""
	mainGame.onStateChanged("START")
	mainGame.gamePopUp = false
	gamePopUp = false
	mainGame.initRestart()
	
