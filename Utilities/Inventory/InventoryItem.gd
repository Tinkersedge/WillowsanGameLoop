@tool
extends Node2D

@export var itemID: String = "" # unique name in database
@export var edTex: Texture

var scenePath:String = "res://Utilities/Inventory/InventoryItem.tscn"
var playerInRange:bool = false
#Scene tree node reference
@onready var iconSprite = %ItemIcon
@onready var itemTexture:Texture = edTex

func _ready() -> void:
	# Show correct texture in game because it is @tool
	if Engine.is_editor_hint():
		iconSprite.texture = edTex
	else:
		iconSprite.texture = itemTexture

func _process(_delta: float) -> void:
	# Show correct texture in editor
	
		
	if playerInRange and Input.is_action_just_pressed("interact"):
		pickupItem()

func pickupItem():
	var displayName = ItemDatabase.getItemInfo(itemID, "displayName")
	var itemType = ItemDatabase.getItemInfo(itemID, "type")
	var item = {
		"quantity": 1,
		"displayName":displayName,
		"itemID": itemID,
		"itemType": itemType,
		"texture": itemTexture,
		"max_stack": 99
	}
	# Call a function to check if need to do something with quests
	Signals.emit_signal("checkItems", item)
	#print("itemPickedup ", ItemDatabase.getItemInfo(itemID, "type"))
	InventoryManager.addItem(item)
	self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInRange = true
		$Hint.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		playerInRange = false
		$Hint.hide()
