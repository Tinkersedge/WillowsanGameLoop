# QuestData.gd
extends Node



var quests = [
	{
		"id": "testerQuest",
		"name": "Help Tony find gems.",
		"npc": "Tony",
		"state": QuestMgr.QuestState.UNLOCKED,
		"questMatter": "side",
		"description": "Tony needs money. Find gems.",
		"taskType": "collection",
		"requirements": {
			"collectionItem": "Gem",
			"found": 0,
			"needed": 2
		},
		"rewards": {
			"xp": 50,
			"item": "bedazzled belt",
			"rp": 50
		},
		"unlocks": ["testerQuest2"]
	},
	{
		"id": "testerQuest2",
		"name": "Show Quentin your house",
		"npc": "Quentin",
		"state": QuestMgr.QuestState.PENDING,
		"questMatter": "side",
		"description": "Quentin likes interior design.",
		"taskType": "location",
		"requirements": {
			"enterHouse": false
		},
		"rewards": {
			"xp": 50,
			"item": "bedazzled belt",
			"rp": 50
		}
	},
]


# Function to retrieve all quests
func get_quests() -> Array:
	return quests

func get_quest_by_id(questID: String) -> Dictionary:
	for quest in quests:
		if quest["id"] == questID:
			return quest
	return {}


func update_quest_state(questID: String, new_state: QuestMgr.QuestState):
	for quest in quests:
		if quest["id"] == questID:
			quest["state"] = new_state
			print("Quest ", questID, " updated to state: " , new_state)


func get_task_progress(task) -> String:
	var task_type = task["taskType"]
	
	match task_type:
		"collection":
			return "%s (%d/%d)" % [
				task["requirements"]["collectionItem"],
				task["requirements"]["found"],
				task["requirements"]["needed"]
			]
		"destination":
			return task["requirements"]["reqText"]
		_:
			return "No progress tracking available"
