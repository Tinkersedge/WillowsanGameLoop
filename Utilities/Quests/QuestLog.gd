#QuestLog.gd
extends CanvasLayer


@onready var activeQuests = $Background/QuestTabs/ActiveQuests/ScrollList/QuestList
@onready var completedQuests = $Background/QuestTabs/CompletedQuests/ScrollList/QuestList
@onready var tashaTasks = $Background/QuestTabs/TashaTasks/ScrollList/QuestList
@onready var questDetails = %QuestDetails
@onready var questLogButton = preload("res://Utilities/Quests/QuestLogButton.tscn")
@onready var TodoQuestItem = preload("res://Utilities/Quests/ToDoQuestItem.tscn")

func _ready() -> void:
	hide()
	Signals.questAssigned.connect(fill_quest_log)
	Signals.questUpdated.connect(fill_quest_log)
	fill_quest_log("")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("openQuests"):
		self.visible = !self.visible


func fill_quest_log(_assignedQuest = null):
	# Clear previous data
	clearTabs()

	# Loop through QuestData and TashaTasksData
	for quest in QuestData.quests:
		# Set ToDo list quest info??
		var questButton = questLogButton.instantiate()
		questButton.text = quest["name"]
		questButton.pressed.connect(self.questSelected.bind(quest))
		
		# Set Quest log list info
		var todoQuestItem = TodoQuestItem.instantiate()
		
		var progress_text = QuestData.get_task_progress(quest)
		
		# Use set_quest to update quest details
		questButton.set_quest_details(quest["name"], progress_text)
		todoQuestItem.set_quest(quest["name"],progress_text)
		
		
		if quest["taskType"] == "TashaTask":
			tashaTasks.add_child(questButton)
		elif quest["state"] == QuestMgr.QuestState.ACTIVE or quest["state"] == QuestMgr.QuestState.TURN_IN:
			activeQuests.add_child(questButton)
		elif quest["state"] == QuestMgr.QuestState.DONE:
			completedQuests.add_child(questButton)
			


func clearTabs():
	for child in activeQuests.get_children():
		child.queue_free()
	for child in completedQuests.get_children():
		child.queue_free()
	for child in tashaTasks.get_children():
		child.queue_free()


func questSelected(quest):
	#print("Getting details for ", quest)
	questDetails.text = "Quest Name: " + quest["name"] + "\n" + "Description: " + quest["description"]
	

func _on_close_me_pressed() -> void:
	hide()
