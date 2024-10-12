# DialogPop
extends CanvasLayer

var choiceButton = preload("res://DialogueStuff/ChoiceButton.tscn")
var showTranslation: bool = false
var npc_name: String = ""
var currentChat:= {}

@onready var ktext = %KoreanText
@onready var etext = %EnglishText
@onready var etogg = %EnglishToggle
@onready var sentContainer = %KoreanSentence
@onready var choiceContainer = %ChoiceContainer
@onready var nextButton = %Continue
@onready var wordButtons = preload("res://DialogueStuff/WordButton.tscn")

func _ready():
	print("initiating.... Dialog Pop")
	#ChatDataMgr.loadTalkData()
	#display_chat("1")
	etogg.toggled.connect(showEnglish)
	nextButton.pressed.connect(nextChat)

func startChat(chat: Dictionary, npcName: String):
	#currentChat = ChatDataMgr.get_chat_by_id(id)
	self.npc_name = npcName
	currentChat = chat
	#print(currentChat)
	if currentChat != {}:
		setUpButtons(currentChat.korean) #Show Korean text as buttons
		etext.text = currentChat.english #Set English text
		etext.visible = false # Hide English text until toggled
	else:
		print("Chat with ID  not found.")





func display_chat(id: String, _npcName: String):
	currentChat = ChatDataMgr.get_chat_by_npc(npc_name, id)
	#print(currentChat)
	if currentChat != {}:
		setUpButtons(currentChat.korean) #Show Korean text as buttons
		etext.text = currentChat.english #Set English text
		etext.visible = false # Hide English text until toggled
	else:
		print("Chat with ID ", id, " for NPC ", npc_name, " not found.")

func setUpButtons(paragraph: String):
	# Clear previous buttons before adding new ones
	for i in range(sentContainer.get_child_count() - 1, -1, -1):
		sentContainer.get_child(i).queue_free()
		
		
	# Split paragraph into words
	var pagewords = paragraph.split(" ")
	# Loop through each word and create button/label
	for i in range(pagewords.size()):
		var word = pagewords[i]
		var clean_word = strip_punctuation(word)
		
		if clean_word in VocabMgr.knownWords or clean_word in VocabMgr.cardDeck:
			# Create a button for words
			var wordButton = wordButtons.instantiate()
			wordButton.text = word
			wordButton.mouse_entered.connect(_on_word_hovered.bind(wordButton, clean_word))
			wordButton.pressed.connect(_on_word_clicked.bind(wordButton, clean_word))
			if clean_word in VocabMgr.knownWords:
				wordButton.add_theme_color_override("font_color", "lightblue")
			elif clean_word in VocabMgr.cardDeck:
				wordButton.add_theme_color_override("font_color", "lightgreen")
			sentContainer.add_child(wordButton)
		else:
			var label = Label.new()
			label.text = word  # Set the text for the non-interactive word
			label.add_theme_font_size_override("font_size", 36)
			sentContainer.add_child(label)
			

func _on_word_hovered(butt, word):
	#print("you are hovering over ", butt , "  " , word)
	var entry = VocabData.getEntry(word)
	if entry != null:
		if word in VocabMgr.knownWords or word in VocabMgr.cardDeck:
			butt.tooltip_text = entry["eword"]
		else:
			butt.tooltip_text = ""

func _on_word_clicked(_wordButton, word):
	#print("you clicked on ", word)
	var entry = VocabData.getEntry(word)
	if entry != null:
		PopUps.showMe("WordPop", entry["eword"])
	else:
		print("word not found")


func showEnglish(_toggled):
	showTranslation = !showTranslation
	etext.visible = showTranslation

# Removes punctuation from word
func strip_punctuation(word):
	var punctuation_chars = [",", ".", "!", "?", "\"", "'"]
	for item in punctuation_chars:
		word = word.replace(item, "")
	return word


func highlight_text(text):
	var highlighted_text = ""
	for word in text.split(" "): # Split sentence into words
		var clean_word = strip_punctuation(word) # removes punctuation
		if clean_word in VocabMgr.knownWords:
			highlighted_text += "[color=lightblue]" + word + "[/color] "
		elif clean_word in VocabMgr.cardDeck:
			highlighted_text += "[color=lightgreen]" + word + "[/color] "
		else:
			highlighted_text += word + " "
	return highlighted_text

func nextChat() -> void:
	# Go to next part of conversation
	#print("you hit the nextChat button ", currentChat.has("next_chat"))
	if currentChat.size() > 0 and currentChat.has("next_chat"):
		display_chat(currentChat["next_chat"], npc_name)
	elif currentChat.has("responses"):
		print("Displaying response choices")
		displayResponses(currentChat["responses"], npc_name)
	else:
		endChat()
		print("no next chat available")


func displayResponses(responses: Array, _npcName: String):
	# Clear previous buttons or chat elements
	for i in range(choiceContainer.get_child_count() -1, -1, -1):
		choiceContainer.get_child(i).queue_free()
	
	# Loop through responses and make a button for each response
	for response in responses:
		var response_button = choiceButton.instantiate()
		response_button.get_node("%Response").text = response["text_kr"]
		response_button.pressed.connect(choicePicked.bind(response["next_chat"], npc_name))
		
		choiceContainer.add_child(response_button)
	
	nextButton.visible = false


func choicePicked(next_chat_id: String, _npcName: String):
	# Clear Buttons 
	for i in range(choiceContainer.get_child_count() -1, -1, -1):
		choiceContainer.get_child(i).queue_free()
	
	
	print("You selected a response. Moving to dialog ID ", next_chat_id)
	nextButton.visible = true
	display_chat(next_chat_id, npc_name)


func endChat():
	print("Chat ended")
	nextButton.visible = false
	etext.text = ""
	# TODO: figure how to empty containers
	#sentContainer.clear_children()
	#choiceContainer.clear_children()
	self.queue_free()
