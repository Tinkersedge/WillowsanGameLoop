extends Button
class_name QuestLogButton

# Assuming you will have these UI elements in your questLogButton scene
#@onready var titleButton = $TitleButton
#@onready var progressLabel = $ProgressLabel
#@onready var npcImage = $NPCImage
#@onready var rewardText = $RewardText

# Function to set quest details
func set_quest_details(quest_name:String,progress_text:String):
	text = quest_name
	$ProgressLabel.text = progress_text
	#npcImage.texture = npc_image
	#rewardText.text = reward_text
	
