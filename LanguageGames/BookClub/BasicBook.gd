extends Sprite2D

@onready var bookName = Global.booksOwned[0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Inside basic book, the book name is " , bookName)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
