extends Area2D

var atBookcase:bool = false
#var bookcaseOpen:bool = false

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if atBookcase and Global.bookcaseOpen == false and Input.is_action_just_pressed("talk"):
		#print("Global.booksOwned is ", Global.booksOwned.size())
		if Global.booksOwned.size() > 0:
			#print("time to open bookcase")
			Global.bookcaseOpen = true
			#$%BookcasePop.show()
			PopUps.showMe("BookcasePop", null)
			get_tree().paused = true
		else:
			print("you don't own any books yet.")
			# TODO: Add Warning about no books into bookcase scene
	



func _on_area_entered(_area: Area2D) -> void:
	atBookcase = true
	$%Hint.show()


func _on_area_exited(_area: Area2D) -> void:
	atBookcase = false
	$%Hint.hide()
