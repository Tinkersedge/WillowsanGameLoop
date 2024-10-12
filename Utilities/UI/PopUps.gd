## PopUps.gd
extends CanvasLayer

var currentPop


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func showMe(showWhat, stuff):
	currentPop = showWhat
	match showWhat:
		"WordPop":
			$WordPop.show()
			$WordPop.fillText(stuff)
			# stuff includes entire wordResource
		"BookcasePop":
			$%BookcasePop.show()
			$%BookcasePop.openBookshelf()
		"ReadBook":
			$Book_Base.show()
			$Book_Base.openBook(stuff)
		"PlantGame":
			$PlantGame.show()
			$PlantGame.start()
			#$PlantGame.gardenTime()
			get_tree().paused = true
