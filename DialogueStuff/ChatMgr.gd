# ChatMgr
extends Node

@onready var chatPopScene = preload("res://DialogueStuff/Ball1.tscn")
@onready var chatDataMgr = ChatDataMgr

# Call this func to start conversation with NPC
func startNPCchat(npcName: String, chat_id: String):
	var currentScene = get_tree().current_scene
	var chat = chatDataMgr.get_chat_by_npc(npcName, chat_id)
	if chat != {}:
		print("Starting chat for ", npcName)
		print(chat)
		# Pass the chat to the chat system to display
		#ChatPop.display_chat(chat)
		var chatPop = chatPopScene.instantiate()
		currentScene.add_child(chatPop)
		chatPop.startChat(chat, npcName)
	else:
		print("No conversation found for ", npcName)
