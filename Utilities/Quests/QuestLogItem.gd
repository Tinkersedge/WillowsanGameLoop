#QuestLogItem.gd
extends VBoxContainer
class_name QuestItem

@onready var detailsContainer = $MarginContainer
@onready var titleButton = $TitleButton
@onready var itemList = %ItemList

var is_expanded = false

# Set up title and hide details
func _ready() -> void:
	detailsContainer.hide()
	titleButton.pressed.connect(toggle_details)

func toggle_details():
	is_expanded = !is_expanded
	if is_expanded:
		detailsContainer.show()
	else:
		detailsContainer.hide()
	release_focus()


# Set details of button and list
func set_quest(quest_name: String, progress_text: String) -> void:
	print("does titleButton exist?" , $TitleButton)
	$TitleButton.text = quest_name
	for child in %ItemList.get_children():
		print("clearning childrng")
		child.queue_free()
	
	if progress_text != "":
		%ItemList.add_item(progress_text)


# Update progress
func _update_progress(_progress_text: String):
	# Update logic goes here NOT WORKING YET
	#itemList.add_item(progress_text)
	pass
