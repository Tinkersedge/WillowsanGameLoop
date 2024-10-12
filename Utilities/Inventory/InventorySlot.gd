# InventorySlot.gd
extends PanelContainer
class_name InventorySlot

var current_item = null # Storing current item in slot

@onready var spotTexture: TextureRect = %SpotTexture
@onready var quantityLabel: Label = %ItemQuantity
@onready var invUI: InventoryUI = Inventory.get_node("%InventoryUI")
@onready var invMgr: InventoryManager = InventoryManager

func set_item(item) -> void:
	current_item = item.duplicate()
	if current_item != null:
		spotTexture.texture = current_item["texture"]
		tooltip_text = "%s\n%s" % [item["displayName"], item["itemType"]]
		# Only show quantity if more than 1
		if item["quantity"] > 0:
			quantityLabel.text = "x%s" % item["quantity"]
			quantityLabel.show()
		else:
			quantityLabel.hide()
	else:
		set_empty()

func set_empty():
	current_item = null
	spotTexture.texture = null
	quantityLabel.text = ""
	quantityLabel.hide()


# *********************************************************************
# *********************   Move Items Logic STARTED *************************
# *********************************************************************
func _on_item_button_pressed() -> void:
	#print("are you holding an item when you clicked? ", invMgr.is_holding_item)
	if not invMgr.is_holding_item:
		if current_item != null:
			# Pick up item if slot is not empty
			if Input.is_key_pressed(KEY_SHIFT):
				# pick up just one
				justPickUpOne()
			else:
				# Pick up the whole stack
				#print(" Picking up the entire stack ", current_item)
				invMgr.pickUpItem(current_item)
				set_empty()
				#print("you have picked up an item..... ", invMgr.held_item)
				invUI.update_inventory(self)
				
	else:
		# if we are holding something
		#print("you are holding an item.... " , invMgr.held_item)
		if current_item == null:
			#print("you clicked on an empty spot")
			# Place item into slot if slot is empty
			set_item(invMgr.held_item)
			invMgr.placeItem(invMgr.held_item, invUI.get_slot_index(self))
			invMgr.clear_held_item()
			#print("you have placed an item in the slot")
		else:
			#print("you clicked on a taken spot, swap now")
			# if slot not empty, but same item there
			if invMgr.held_item["itemID"] == current_item["itemID"]:
				# Merge stack if same
				#print("Merging items into a stack.....")
				mergeStacks(current_item)
			else:
				# If slot not empty, and not the same, swap items
				#print("Swapping items now.....")
				var temp_item = current_item
				invMgr.swapItems(temp_item, invUI.get_slot_index(self))
				#print("Inside SLOT, Items have been swapped, you are holding  ", invMgr.held_item)
				#invMgr.clear_held_item()
				set_item(invMgr.held_item)
				#invUI.update_inventory(self)
				#print("Items have been swapped, and ui should reflect that.")
				


func justPickUpOne():
	var singleItem = {
		"quantity": 1,
		"displayName": current_item["displayName"],
		"itemID": current_item["itemID"],
		"itemType": current_item["itemType"],
		"texture": current_item["texture"],
		"max_stack": 99
	}
	invMgr.pickUpItem(singleItem)
	
	if current_item["quantity"] <= 0:
		set_empty()
		invMgr.clear_slot(invUI.get_slot_index(self))
	else:
		set_item(current_item)
		#print("******* INside slot, after setting item, current item has " ,current_item["quantity"])
	#invMgr.update_inventory_slot(invUI.get_slot_index(self), current_item)
	#print("Picked up just one from the stack ", singleItem)

func mergeStacks(target_item):
	# Add quanitites from held item to target item
	 # Combine the held item and the target item into one stack
	target_item["quantity"] += invMgr.held_item["quantity"]
	invMgr.clear_held_item() # Clear held item after merging
	invUI.update_inventory(self)
	#print("Merged items, target now has: ", target_item["quantity"])
	# Update visuals and inventory
	#set_item(target_item)
	#invUI.update_inventory(self)


# *********************************************************************
# *********************   Move Items Logic ENDED *************************
# *********************************************************************
