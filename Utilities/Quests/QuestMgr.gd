# QuestMgr.gd
extends Node

@onready var quest_data = QuestData

enum QuestState {
	PENDING, # On NPC list, not yet available to player
	UNLOCKED, # Unlocked and available for NPC, board, mailbox
	ACTIVE, # Player has accepted the quest
	TURN_IN, # Quest requirements met, ready to turn in
	DONE, # Quest turned in and completed
	CANCELED # Quest canceled or abandoned
	}

var activeQuests = [] # stores currently active questions
var completedQuests = [] # track completed quests


func _ready() -> void:
	Signals.checkItems.connect(updateQuestItems)
	Signals.checkLocation.connect(locationCheckIn)
	


# get unlocked quests for specific npc
func get_valid_quests(npcName: String) -> Array:
	var validQuests := []
	for quest in QuestData.quests:
		if quest["npc"] == npcName and quest["state"] in [QuestState.UNLOCKED, QuestState.ACTIVE, QuestState.TURN_IN]:
			validQuests.append(quest)
	return validQuests

func progress_quests(npcName:String):
	# Retrieve all valid quests for the given NPC
	var validQuests = get_valid_quests(npcName)
	for quest in validQuests:
		if quest["state"] == QuestState.TURN_IN:
			print("Quest ", quest["name"] , " is completed. Moving to DONE")
			complete_quest(quest["id"])
			# Trigger UI and rewards here
			unlockNextQuests(quest["id"])
			return # Stop, wait for UI to complete before progressing
	# Handle UNLOCKED and move to ACTIVE
	for quest in validQuests:
		if quest["state"] == QuestState.UNLOCKED:
			# move quest to ACTIVE
			assign_quest(quest["id"])
			# Start quest and trigger relevant dialogue
			return # Stop here for now
	# Handle ACTIVE: provide feedback or help
	for quest in validQuests:
		if quest["state"] == QuestState.ACTIVE:
			if quest.has("collectionItem"):
				check_collection_quest(quest)
			elif quest.has("npcTalk"):
				check_npc_talk_quest(quest)
			# do not move, just help
		
		# Emit signal to update UI with active quest
		Signals.questAssigned.emit(quest)
		return


# get quest status by ID
func get_quest_status(questID: String):
	var quest = quest_data.get_quest_by_id(questID)
	if quest != {}:
		return quest["state"]


func assign_quest(questID: String):
	var quest = quest_data.get_quest_by_id(questID)
	if quest != {}:
		if quest["state"] == QuestState.UNLOCKED:
			quest_data.update_quest_state(questID, QuestState.ACTIVE)
			activeQuests.append(quest)
			print("Assigned quest: " , quest["name"])
			# check if already have items needed for quest
			check_existing_items_for_quest(quest)
			# Update UI items about quest
			Signals.questAssigned.emit(quest)
			print("Signal sent to quest assigned.....")
		else:
			print("Quest ", questID , " is not in UNLOCKED state")
	else:
		print("Quest not found")


func check_existing_items_for_quest(quest: Dictionary):
	var player_items = InventoryManager.inventory
	print("your inventory is " , player_items)
	for item in player_items:
		if item != null:
		# make sure not null
			print(item.has("itemID"))
			print("Does this quest have collection ", quest["requirements"].has("collectionItem"))
			if item.has("itemID") and quest["requirements"].has("collectionItem"):
				
				if item["itemID"] == quest["requirements"]["collectionItem"]:
					quest["requirements"]["found"] += item["quantity"]
					
	if quest["taskType"] == "collection":
		check_collection_quest(quest)


func check_collection_quest(quest):
	var progress = quest["requirements"]
	if progress["found"] >= progress["needed"]:
		print("Collection quest completed ", quest["name"])
		complete_quest(quest["id"])


func check_npc_talk_quest(quest):
	if quest["npcTalk"] == true:
		print("Conversation quest completed ", quest["name"])
		complete_quest(quest["id"])


func check_quest_progress(questID: String):
	for quest in activeQuests:
		if quest["id"] == questID:
			var progress = quest["requirements"]
			if progress["found"] >= progress["needed"]:
				complete_quest(questID)


func complete_quest(questID: String):
	var quest = quest_data.get_quest_by_id(questID)
	if quest != {}:
		if quest["state"] == QuestState.ACTIVE:
			if quest["taskType"] == "location":
				quest_data.update_quest_state(questID, QuestState.DONE)
				completedQuests.append(quest)
				activeQuests.erase(quest)
				print("Location quest done: ", quest["name"])
				# Grant rewards here
			else:
				quest_data.update_quest_state(questID, QuestState.TURN_IN)
				print("Completed quest: ", quest["name"])
			Signals.emit_signal("questStateChanged")
			Signals.questUpdated.emit()
				# Grant rewards here
		elif quest["state"] == QuestState.TURN_IN:
			quest_data.update_quest_state(questID, QuestState.DONE)
			completedQuests.append(quest)
			activeQuests.erase(quest)
			print("Done quest: ", quest["name"])
			Signals.emit_signal("questStateChanged")
			Signals.questUpdated.emit()
			
		else: # addin if completed, make it DONE
			print("Quest ", questID, " is not in ACTIVE state")
	else:
		print("Quest not found")


func unlockNextQuests(questID: String):
	
	var quest = quest_data.get_quest_by_id(questID)
	if quest.has("unlocks"):
		print("unlocking more quests....", questID)
		for unlockID in quest["unlocks"]:
			var unlockQuest = quest_data.get_quest_by_id(unlockID)
			print("now looking at unlock ID ", unlockID)
			if unlockQuest != {} and unlockQuest["state"] == QuestState.PENDING:
				quest_data.update_quest_state(unlockID, QuestState.UNLOCKED)
				print("unlocked quest: " , unlockQuest["name"])
		Signals.emit_signal("questStateChanged")
		Signals.questUpdated.emit(quest)


func get_active_quests() -> Array:
	return activeQuests


func updateQuestItems(item):
	#print("You have picked up ", item ," with type ", item["itemID"])
	# run through activeQuests 
	print("The active quests are ", activeQuests)
	for quest in activeQuests:
	# see if anyone wants this itemID (coin, gem, seeds...)
		if quest["requirements"]["collectionItem"] == item["itemID"]:
		# if so, add to the quantity held
			quest["requirements"]["found"] += 1
			print(quest["requirements"]["found"])
			# check if you have enough now to complete task
			if quest["requirements"]["found"] >= quest["requirements"]["needed"]:
				quest["state"] = QuestState.TURN_IN
				print("you have completed ", quest["name"], " with ", item)
				# TODO: Pop up need to go back to quest give with items
			Signals.questUpdated.emit(quest)

func locationCheckIn(location):
	for quest in activeQuests:
		if quest["requirements"].has(location) and quest["state"] == QuestState.ACTIVE:
			quest["requirements"][location] = true
			check_quest_completion(quest["id"])


func check_quest_completion(questID: String):
	var quest = quest_data.get_quest_by_id(questID)
	if quest !={} and quest["state"] == QuestState.ACTIVE:
		var all_requirements_met = true
		for requirement in quest["requirements"]:
			if quest["requirements"][requirement] == false:
				all_requirements_met = false
				break
		if all_requirements_met:
			complete_quest(questID)
			
