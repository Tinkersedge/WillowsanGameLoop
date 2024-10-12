extends Control
class_name Spinner

@export var is_spinning: bool = false
@export var speed: int = 10
@export var power: int = 2
@export var reward_position = 0

# Each zone represents a type of task. 
# tashaTasks = dictionary of at least 3 tasks per type
# TashaTaskMgr will receive the signal and assign a task from the dictionary

var zones = [
	{
		"name": "Dark blue",
		"from": 0,
		"to": 45,
		"tashaTaskNum": 1,
		"zoneText": "Conversations"
	},
	{
		"name": "Dark green",
		"from": 45,
		"to": 90,
		"tashaTaskNum": 2,
		"zoneText": "Word Discovery"
	},
	{
		"name": "Blue",
		"from": 90,
		"to": 135,
		"tashaTaskNum": 3,
		"zoneText": "Food Discovery"
	},
	{
		"name": "Yellow",
		"from": 135,
		"to": 180,
		"tashaTaskNum": 4,
		"zoneText": "Weather"
	},
	{
		"name": "Purple",
		"from": 180,
		"to": 225,
		"tashaTaskNum": 5,
		"zoneText": "Review"
	},
	{
		"name": "Green",
		"from": 225,
		"to": 270,
		"tashaTaskNum": 6,
		"zoneText": "Translation"
	},
	{
		"name": "Orange",
		"from": 270,
		"to": 315,
		"tashaTaskNum": 7,
		"zoneText": "Current Events"
	},
	{
		"name": "Pink",
		"from": 315,
		"to": 360,
		"tashaTaskNum": 8,
		"zoneText": "Vacation"
	}
	#{
		#"name": "Teal",
		#"from": 330,
		#"to": 360,
		#"tashaTaskNum": 9,
		#"zoneText": "Vacation"
	#}
	]

func letsSpin():
	if is_spinning == false:
		is_spinning = true
		var tween = get_tree().create_tween().set_parallel(true)
		tween.connect("finished", func():
			#after tween finish animation, this function is call
			var old_rotation_degrees = %Front.rotation_degrees
			#set is_spin = false to tell for user can press again
			is_spinning = false
			if old_rotation_degrees > 360:
				#This part is to fix the error that when rotating the steamer once, it will not rotate counterclockwise
				var rad_ = fmod(old_rotation_degrees, 360)
				%Front.rotation_degrees = rad_
			)
		reward_position = randi_range(0, 360) #random position from 0 to 360 degrees

		for item in zones:
			var midpoint_offset = (item.to - item.from)/2
			if reward_position >= item.from - midpoint_offset and reward_position <= item.to - midpoint_offset:
				#print(item.name)
				#signal for another scene
				Signals.tashaTaskChosen.emit(item.tashaTaskNum)
				hide()
		tween.tween_property(%Front, "rotation_degrees", reward_position +  360 * speed * power , 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		#tween.finished
	
