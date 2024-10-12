extends Node

# Seeds Array - filled dynamically

var seedPacks: Array
var seeds_animals:Array
var seeds_bodyParts:Array
var seeds_clothing:Array
var seeds_colors:Array
var seeds_days:Array
var seeds_jobs:Array
var seeds_months:Array
var seeds_nature:Array
var seeds_numbersK:Array
var seeds_relationships:Array
var seeds_sports:Array
var seeds_transport:Array

var seeds_animals_info = [0, 0, 1, false] #PlantStage, #terms, #section, allIntro
var seeds_bodyParts_info = [0, 0, 1, false]
var seeds_clothing_info = [0, 0, 1, false]
var seeds_colors_info = [0, 0, 1, false]
var seeds_days_info = [0, 0, 1, false]
var seeds_jobs_info = [0, 0, 1, false]
var seeds_months_info = [0, 0, 2, false]
var seeds_nature_info = [0, 0, 1, false]
var seeds_numbersK_info = [0, 0, 1, false]
var seeds_relationships_info = [0, 0, 1, false]
var seeds_sports_info = [0, 0, 1, false]
var seeds_transport_info = [0, 0, 1, false]

var smallSeedPacks:Array = []
var largeSeedPacks:Array = []

var currentSeeds:Array = []
var currentSeedStage = 0


func _ready():
	makeSeedPack() # Goes through dictionary and fills all arrays
	#break_into_syllables("물고기")
	#startPlantGame("seeds_days")


#*********************************************************************
#************************    SEED GAME STUFF ****************
#*********************************************************************

func makeSeedPack(): # Fills in ALL seeds arrays with words
	# Goes through vocabData, if has seedpack, pushes word into ind seedpack array
	for i in range(VocabData.wordInfo.size()):
		var currentWord = VocabData.wordInfo.keys()[i]
		var currentSeedPack = VocabData.wordInfo[currentWord]["SeedPack"]
		if not currentSeedPack:
			pass
		else: # if there is a seedpack listed
			# delete this line after removing "" from table
			currentSeedPack = currentSeedPack.replace('"', '')
			# sets 'arrayName' to seeds_colors...
			var arrayName = "seeds_" + str(currentSeedPack)
			# pushes current word into seeds_colors
			get(arrayName).push_back(currentWord)
			# adds seeds_colors to main seedPacks array
			if not arrayName in seedPacks:
				seedPacks.push_back(arrayName)
	
	# goes through each seedpack inside the main seedPacks array and fills seedpack array
	for seedPack in seedPacks: 
		var seedPackArray = get(seedPack) # look at seedpack arrays
		var fullContentArray = basicGameArray(seedPackArray)
		set(seedPack, fullContentArray)
	# for each seedPack, sets up seedPack_info, and makes [1] = # of words in seedPack
	for seedPack in seedPacks: # Saving how long the array is
		var seedPackInfo = str(seedPack) + str("_info")
		get(seedPackInfo)[1] += get(seedPack).size()
		if get(seedPack).size() >= 10:
			largeSeedPacks.push_back(str(seedPack))
		elif get(seedPack).size() <= 9:
			smallSeedPacks.push_back(str(seedPack))
	
		

# basicGameArray returns array with (eword, kword, syllables, def, picture, audio, seedsection)
# should be able to use this array for all three types of games
func basicGameArray(seedArray) -> Array: 
	var gameArray:Array = []
	var multSects = false
	var seedSect = 1
	var counter = 0
	
	if seedArray.size() >= 10: #have to introduce words in more than one session
		multSects = true
		
	for word in seedArray: # for each word in the seedArray
		if multSects == false: #if no multisect, then always seedSect 1
			seedSect = 1
		elif multSects == true: # otherwise, every 5 is a new seedSect
			counter += 1
			if counter >5 and counter % 5 == 1:
				seedSect += 1
		# Grab data for each word then return
		var entry = [
			VocabData.wordInfo[word].get("eword", ""),
			VocabData.wordInfo[word].get("kword", ""),
			VocabData.wordInfo[word].get("syllables", ""),
			VocabData.wordInfo[word].get("definition", ""),
			VocabData.wordInfo[word].get("picture", ""),
			VocabData.wordInfo[word].get("other1", ""), # in future 'audio',
			VocabData.wordInfo[word].get("timesCorrect", ""),
			VocabData.wordInfo[word].get("timesWrong", ""),
			seedSect
		]
		gameArray.append(entry)
	#print(gameArray)
	return(gameArray)

# fills in currentSeeds array if word is in correct section
func assessPlant(seedsToPlant): 
	# This function handles making the game array (currentSeeds)
	# based on what section each seed pack is on (based on length)
	var currentSeedPack = get(seedsToPlant)
	var currentSeedInfo = get(str(seedsToPlant) + "_info")
	#print("current seed pack is " , get(seedsToPlant))
	#print(currentSeedInfo)
	# Check the total number of terms in pack
	if str(seedsToPlant) in smallSeedPacks:
		for seedWords in currentSeedPack.size():
			if currentSeedPack[seedWords][8] <= currentSeedInfo[2]:
				currentSeeds.push_back(currentSeedPack[seedWords])
				#print(currentSeeds)
	elif str(seedsToPlant) in largeSeedPacks:
		#print("break this down into smaller group")
		for seedWords in currentSeedPack.size():
			# if seedSect < = current Section, then push it to currentSeeds array
			if currentSeedPack[seedWords][8] <= currentSeedInfo[2]:
				currentSeeds.push_back(currentSeedPack[seedWords])
				
	# double the terms and add "K2E" or "E2K" at the end
	currentSeeds = doubleTermsArray(currentSeeds)
	currentSeeds.shuffle()
	#print("current seeds is " , currentSeeds)
				
	# checkPlantStage determines and sets which stage the plant should be at
	# so you can know which type of game to show
	#print("right before calling checkPlantStage, seedsToPlant is ", seedsToPlant)
	var stageNeeded = checkPlantStage(seedsToPlant)
	return stageNeeded


# Func startPlantGame is complete, game array currentSeeds has been made
# Now let's double it and make sure we know k2e or e2k
func doubleTermsArray(termArray:Array) -> Array:
	var doubledArray: Array = []
	for term in termArray:
		var koreanToEnglish = term.duplicate()
		koreanToEnglish.append("K2E")
		doubledArray.append(koreanToEnglish)
		
		var englishToKorean = term.duplicate()
		englishToKorean.append("E2K")
		doubledArray.append(englishToKorean)
	
	return doubledArray


# Checks the stage the plant is 0 - 4 to know which game to start
func checkPlantStage(seedsPlanted) -> int:
	var currentSeedInfo = get(str(seedsPlanted) + "_info")
	var counts = {
		4: 0,
		6: 0,
		8: 0,
		10: 0
	}

	#print("currently checking plant stage ", seedsPlanted)
	for plant in get(seedsPlanted):
		#******************** testing random values
		#var random_times_correct = (randi() % 16 + 2)
		#plant[6] = random_times_correct
		#********************************************
		
		#print(plant[6])
		# In case they have gotten them right an odd number of times
		var correct_times = plant[6]
		
		# adjust odd numbers to next lowest even number, limit to 10
		if correct_times > 10:
			correct_times = 10
		elif correct_times == 0:
			correct_times = 0
		elif correct_times %2 != 0:
			correct_times -= 1
		
		# Update the count for the adjusted values
		if correct_times in counts:
			counts[correct_times] += 1
		
		# Determine the stage based on the counts
		var totalPlants = get(seedsPlanted).size()
		#print(counts)
		#print(floor(totalPlants * 0.75))
		# plant is large and goal is blooming
		if counts[10] >= totalPlants:
			#print("you have finished this seed Pack")
			currentSeedInfo[0] = 4
			currentSeedStage = 4
		# plant is medium - goal is large and new pot
		elif counts[8] + counts[10] >= totalPlants:
			#print("you are moving to large plant")
			currentSeedInfo[0] = 3
			currentSeedStage = 3
		# plant is seedling - goal is medium
		elif counts[6] + counts[8] + counts[10]>= floor((totalPlants * 0.75)):
			#print("you are moving to medium plant")
			currentSeedInfo[0] = 2
			currentSeedStage = 2
		#Seed just planted - goal is seedling
		elif counts[4] + counts[6] + counts[8] + counts[10] >= floor((totalPlants /2)):
			#print("you are moving to seedling")
			currentSeedInfo[0] = 1
			currentSeedStage = 1
	return currentSeedStage
	# Now to start the game based on the stage
	

func getCurrentSeeds() -> Array:
	return currentSeeds.duplicate()

func updateDict(word: String, response: String):
	var dic = VocabData.wordInfo
	if response == "correct":
		dic[word]["timesCorrect"] += 1
	elif response == "wrong":
		dic[word]["timesWrong"] += 1
	dic[word]["timesSeen"] += 1
	dic[word]["seen"] = true
	#print(dic[word])

func resetGame():
	currentSeeds.clear()







# This function will break any word into syllables
func break_into_syllables(word: String) -> Array:
	var result = []
	for i in range(word.length()):
		result.append(word.substr(i, 1)) # Extract each character as a syllable
	#print(result)
	return result
