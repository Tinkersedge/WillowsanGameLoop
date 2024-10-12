extends TextureButton


@export var objectE:String = "photo"
@export var objectName:String = "photo"


var areaActive = false
var wordClicked = false
var wordData: Dictionary

func _ready() -> void:
	#$WordHover.hide()
	wordData = VocabData.wordInfo[objectE]
	$WordHover.text = wordData["kword"]
	

func _process(_delta:float) -> void:
	# if mouse over object AND clicked
	if areaActive and wordClicked:
		$WordHover.show()
		wordClicked = false
		# Pop up the WordPop for this word
		PopUps.showMe("WordPop", objectE)
		get_tree().paused = true
	# if mouse over object, not clicked
	elif areaActive == true:
		#print("should be showing word")
		$WordHover.show()
	# if mouse is NOT over object
	elif areaActive == false:
		$WordHover.hide()



func _on_mouse_entered() -> void:
	#print("mouse hover")
	areaActive = true

func _on_mouse_exited() -> void:
	#print("mouse not hover")
	areaActive = false

func _on_pressed() -> void:
	#print("mouse clicked")
	wordClicked = true
