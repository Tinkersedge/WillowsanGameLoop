extends Node


var cardDeck:Array = ["학교","한국어", "대화"]
var knownWords:Array = ["안녕하세요", "사과", "책", "개"]


func learnNewWord(word):
	if word not in cardDeck:
		cardDeck.append(word)
		#print(word, " added to card deck.")
		#print(cardDeck)

func knownWord(word):
	if word not in knownWords:
		knownWords.append(word)
		#print(word, " added to known words")
		#print(knownWords)

func isWordKnown(word: String) -> bool:
	return word in knownWords

func isWordInDeck(word: String) -> bool:
	return word in cardDeck

# This function processes a sentence and highlights words based on player knowledge
func highlight_words_in_sentence(sentence: String) -> String:
	
	#Split sentence into words
	var words_in_sentence = sentence.split(" ")
	
	# Initialize the final highlighted sentence
	var highlighted_sentence = ""
	
	# Iterate over each word, apply colors
	for word in words_in_sentence:
		if knownWords.has(word):
			highlighted_sentence += "[color=blue]" + word + "[/color] "
		elif cardDeck.has(word):
			highlighted_sentence += "[color=green]" + word + "[/color] "
		else:
			highlighted_sentence += "[color=white]" + word + "[/color] "
	
	#print("highlight words called. ", highlighted_sentence)
	# Return the highlighted sentence
	return highlighted_sentence.strip_edges()
	
