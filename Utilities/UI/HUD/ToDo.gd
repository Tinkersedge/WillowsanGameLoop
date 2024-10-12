# ToDo.gd
extends Control

@onready var todoTodayList = %DailyTaskList
@onready var todoQuestList = %QuestTaskList
@onready var questLogItem = preload("res://Utilities/Quests/QuestLogItem.tscn")


func _ready() -> void:
	print("does quest log item exists? ", questLogItem)
	fill_todo_list()


func fill_todo_list():
	# clear previous items
	for child in todoTodayList.get_children():
		child.queue_free()
	for child in todoQuestList.get_children():
		child.queue_free()
	
	for task in QuestData.quests:
		if task["state"] == QuestMgr.QuestState.ACTIVE and task["taskType"] != "TashaTask":
			var questItem = questLogItem.instantiate()
			var progress_text = QuestData.get_task_progress(task)
			questItem.set_quest(task["name"], progress_text)
			todoQuestList.add_child(questItem)
	
	#for tashaTask in TashaTasksData.active_tasks:
	var tashaTask = TashaTaskMgr.current_task
	if tashaTask != null:
		var tashaTaskItem = questLogItem.instantiate()
		print("Tasha task name is ", TashaTaskMgr.current_task)
		tashaTaskItem.set_quest(tashaTask["name"], {})
		todoTodayList.add_child(tashaTaskItem)


#func update_task_progress(task_name: String, progress: String):
	#for item in todoQuestList.get_children():
		#if item.titleButton.text == task_name:
			#item.update_progress(progress)
	#for item in todoTodayList.get_children():
		#if item.titleButton.text == task_name:
			#item.update_progress(progress)
