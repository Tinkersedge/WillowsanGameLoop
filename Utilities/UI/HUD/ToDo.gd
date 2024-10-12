# ToDo.gd
extends Control

@onready var todoTodayList = %DailyTaskList
@onready var todoQuestList = %QuestTaskList
@onready var questLogItem = preload("res://Utilities/Quests/ToDoQuestItem.tscn")


func _ready() -> void:
	print("does quest log item exists? ", questLogItem)
	Signals.questAssigned.connect(fill_todo_list)
	Signals.questUpdated.connect(fill_todo_list)
	fill_todo_list()


func fill_todo_list(quest = null):
	# clear previous items
	for child in todoTodayList.get_children():
		child.queue_free()
	for child in todoQuestList.get_children():
		child.queue_free()
	
	if quest != null:
		if (quest["state"] == QuestMgr.QuestState.ACTIVE 
		or quest["state"] == QuestMgr.QuestState.TURN_IN 
		and quest["taskType"] != "TashaTask"):
			var questItem = questLogItem.instantiate()
			var progress_text = QuestData.get_task_progress(quest)
			questItem.set_quest(quest["name"], progress_text)
			todoQuestList.add_child(questItem)
	
	#for tashaTask in TashaTasksData.active_tasks:
	var tashaTask = TashaTaskMgr.current_task
	if tashaTask != null:
		var tashaTaskItem = questLogItem.instantiate()
		print("Tasha task name is ", TashaTaskMgr.current_task)
		# TODO: replace "" once progress tracking is in place
		tashaTaskItem.set_quest(tashaTask["name"], "")
		todoTodayList.add_child(tashaTaskItem)




#func update_task_progress(task_name: String, progress: String):
	#for item in todoQuestList.get_children():
		#if item.titleButton.text == task_name:
			#item.update_progress(progress)
	#for item in todoTodayList.get_children():
		#if item.titleButton.text == task_name:
			#item.update_progress(progress)
