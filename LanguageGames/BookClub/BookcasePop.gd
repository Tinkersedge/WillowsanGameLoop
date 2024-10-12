extends CanvasLayer

var bookBody = preload("res://LanguageGames/BookClub/BookshelfBook.tscn")

@onready var shelf = $Shelf/ShelfGrid


func openBookshelf() -> void:
	# TODO: empty bookshelf
	for n in shelf.get_children():
		shelf.remove_child(n)
		n.queue_free()
	for j in Global.booksOwned.size():
		#var currentBook = shelf.get_node("book" + str(j + 1) + "/BookButton")
		#currentBook.show()
		var currentBook = bookBody.instantiate()
		currentBook.get_node("BookButton").tooltip_text = BooksData.getBookTitle(Global.booksOwned[j])
		#print("book connected to readbook")
		currentBook.get_node("BookButton").connect("pressed", readBook.bind(Global.booksOwned[j]))
		currentBook.get_node("BookButton/BasicBook").texture = load(BooksData.getTexture(Global.booksOwned[j]))
		shelf.add_child(currentBook)

func readBook(bookTip):
	#print("time to read a book ", bookTip)
	var bookTitle = BooksData.getBookTitle(bookTip)
	#print("book title is ", bookTitle)
	PopUps.showMe("ReadBook", bookTip)
	



func _on_close_bookcase_pressed() -> void:
	#print("Closing bookcase.....")
	Global.bookcaseOpen = false
	get_tree().paused = false
	hide()
