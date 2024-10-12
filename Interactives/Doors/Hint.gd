extends Label
class_name Hint

func showHint(doorPos:Vector2):
	self.visible = true
	self.global_position = doorPos

func hideHint():
	self.visible = false
	
