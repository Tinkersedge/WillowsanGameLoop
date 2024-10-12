extends CanvasLayer

var pageData:Array

@export var bookToRead:String = ""
var currentText:String = ""
var currentPage:int = 1
#var page1:String = "The red cat sleeps in the apartment window every day."
var wordButtons = preload("res://DialogueStuff/WordButton.tscn")
var bookSentence = preload("res://LanguageGames/BookClub/BookSentence.tscn")

@onready var ksent: VBoxContainer = $Breakdown/SL/PL/KoreanSentences
@onready var esent: VBoxContainer = $Breakdown/SL/PL/EnglishSentences

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$KoreanParagraph.show()
	$Breakdown.hide()
	$VocabList.hide()
	$EndPage.hide()
	#pageData = BooksData.getPageText(bookToRead, "1")
	#setUpSentence(pageData[0])

func openBook(stuff):
	print("Inside BookCatsday, stuff is ", stuff)
	bookToRead = stuff
	pageData = BooksData.fillText(bookToRead)
	
	print(pageData)
	setUpButtons(pageData[0]) #split paragraph into word buttons
	#setUpSentences()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setUpButtons(paragraph):
	#var sentsplit:Array = paragraph.split(" ")
	var pagewords = paragraph.split(" ")
	for i in pagewords.size():
		var wordButton = wordButtons.instantiate()
		wordButton.text = pagewords[i]
		$KoreanParagraph/Sentence.add_child(wordButton)
	
func fillSentences():
	var numSent = BooksData.howLong(bookToRead)
	var sentMade = 1
	# TODO: dynamically create needed text boxes on page, then fill
	while sentMade < (numSent * 2):
		var indSentence = bookSentence.instantiate()
		indSentence.text = pageData[sentMade]
		ksent.add_child(indSentence)
		print("ksent added ", indSentence.text)
		sentMade += 2
	sentMade = 2
	while sentMade <= (numSent * 2):
		var indSentence = bookSentence.instantiate()
		indSentence.text = pageData[sentMade]
		esent.add_child(indSentence)
		print("esent added ", indSentence.text)
		sentMade += 2


func turnPage() -> void:
	# TODO: page turn animation
	# TODO: remove old data, reset page
	# TODO: create next page
	
	currentPage += 1
	if currentPage == 2:
		fillSentences()
		# turn page animation
		resetPage()
		
		$Breakdown.show()
	elif currentPage == 3:
		# TODO: hide esent too
		ksent.hide()
		for n in ksent.get_children():
			ksent.remove_child(n)
			n.queue_free()
		$KoreanParagraph.hide()
		$EndPage.show()
	
	#var totalPages = BooksData.howLong(bookToRead)
	#if currentPage <=  totalPages:
		#print("you can turn the page ", BooksData.howLong(bookToRead))
		## play page turn animation, delete all text
		## load new page
		#resetPage()
		#pageData = BooksData.getPageText(bookToRead, str(currentPage))
		##setUpSentence(pageData[0])
	#else:
		#print("the book is over")
		## time to go to review questions

func resetPage():
	$KoreanParagraph.hide()
	for n in $KoreanParagraph/Sentence.get_children():
		$KoreanParagraph/Sentence.remove_child(n)
		n.queue_free()


func bookClosed() -> void:
	print("Closing book.....")
	hide() # TODO: Make this an animation of it going on shelf?
