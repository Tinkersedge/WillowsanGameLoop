## WordPop.gd
extends CanvasLayer

var currentWord:String
var wordData



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fillText("dog")

func fillText(desiredWord):
	currentWord = desiredWord
	wordData = VocabData.wordInfo[desiredWord]
	#get_tree().paused = true
	
	$Word_Korean.text = wordData["kword"]
	$Word_English.text = wordData["eword"]
	
	$Definition.text = str(wordData.get("definition", ""))
	$OtherStuff.text = str(wordData.get("other1", ""))
	


func _on_close_pop_pressed() -> void:
	print("Closing pop up")
	get_tree().paused = false
	hide()


func addWordToDeck() -> void:
	#print(wordData["eword"] , " is being added to cardDeck")
	VocabMgr.learnNewWord(currentWord)
	#do something here to initialize that word and start tracking it
	#print(VocabMgr.cardDeck)
	


func addWordToKnown() -> void:
	#print(wordData["eword"], " is being added to known words")
	VocabMgr.knownWord(currentWord)
