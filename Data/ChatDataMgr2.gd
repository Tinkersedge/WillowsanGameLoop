# ChatDataMgr
extends Node

var talkData:Dictionary = {} # final dictionary to reference
var data_file_paths = {
	"Tasha":"res://Data/ChatData/tasha.json",
	"Tony":"res://Data/ChatData/tony.json",
	"Quentin":"res://Data/ChatData/quentin.json"
}

func ready():
	#print("initiating ChatDataMgr2...")
	loadAllTalkData()
	#loadTalkData()


func loadAllTalkData():
	for npc_name in data_file_paths.keys():
		loadTalkDataForNPC(npc_name)

func loadTalkDataForNPC(npc_name: String):
	var data_file_path = data_file_paths.get(npc_name, "")
	#print("loading talk data")
	if FileAccess.file_exists(data_file_path): 
		# read the data file (json)
		var dataFile = FileAccess.open(data_file_path, FileAccess.READ)
		# parse the json and save it into talkData dictionary
		var json_text = dataFile.get_as_text()
		dataFile.close()
		
		var parsedJson = JSON.parse_string(json_text)
		if parsedJson is Dictionary:
			talkData[npc_name] = parsedJson
			#print("loaded talk data for ", npc_name)
		else:
			print("Error reading file for ", npc_name)

#func loadTalkData():
	#print("loading talk data")
	#if FileAccess.file_exists(data_file_path): 
		## read the data file (json)
		#var dataFile = FileAccess.open(data_file_path, FileAccess.READ)
		## parse the json and save it into talkData dictionary
		#var json_text = dataFile.get_as_text()
		#dataFile.close()
		#talkData = JSON.parse_string(json_text)
		#if talkData:
			#if talkData is Dictionary: # check that it was done correctly
				#print (talkData)
				#return talkData
			#else:
				#print("Error reading file")
	#else:
		#print("File does not exist")

# use this to get chat data for specific NPC
func get_chat_by_npc(npc_name: String, id: String) -> Dictionary:
	if npc_name in talkData:
		for chat in talkData[npc_name]["chats"]:
			if chat.id == id:
				return chat
	return {}


## use this to get one of the chats by id
#func get_chat_by_id(id: String) -> Dictionary:
	#for chat in talkData.chats: # Look through chats
		#if chat.id == id: # if that id exists, return it
			#return chat
	#return {}
