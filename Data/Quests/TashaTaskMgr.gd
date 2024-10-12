#TashaTaskMgr.gd
extends Node

var current_task = null

func _ready():
	Signals.tashaTaskChosen.connect(tashaTaskSelected)


func tashaTaskSelected(task_num):
	# Pick a task from TashaTasksData category
	var tasks_list = TashaTasksData.tashaTasks[task_num]
	var random_task = tasks_list[randi() % tasks_list.size()]
	
	current_task = random_task
	#print("Selected Tasha Task: " , current_task)
	
	# Add task to quest log
	add_task_to_quest_log(current_task)
	Hud.todo.fill_todo_list()


func add_task_to_quest_log(task):
	# Add this task to QuestData
	var new_task = {
		"name": task["name"],
		"description": task["desc"],
		"state": QuestMgr.QuestState.ACTIVE,
		"taskType": "TashaTask"
	}
	
	QuestData.quests.append(new_task)
	
	# Update the quest log ui
	QuestLog.fill_quest_log()
