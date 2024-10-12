## InventoryManager.gd
extends Node
class_name InvManager

var inventory = [] # start game with empty inventory
var inventorySize = 36 # size of inventory

var held_item = null # stores globally held items when picked up from inventory
var is_holding_item = false # tracks if holding an item moving items in inventory
var dragPreview: TextureRect = null


@onready var inventory_slot_scene = preload("res://Utilities/Inventory/InventorySlot.tscn")

signal inventoryUpdated #emitted when anything changes

func _ready() -> void:
	# Initializes inventory with 32 slots (spread over 8 blocks per row)
	inventory.resize(inventorySize)


func _process(_delta: float) -> void:
	if is_holding_item and dragPreview != null:
		#print("you should be dragging an item")
		dragPreview.position = get_viewport().get_mouse_position() - dragPreview.custom_minimum_size/2
		


#signal inventory_updated
func addItem(item, slot_index: int = -1):
	if item == null:
		#print("Item is null, cannot add it")
		return false
		
	#print("should be adding item.... ", item)
	if slot_index != -1:
		inventory[slot_index] = item
	else:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["itemID"] == item["itemID"]:
				inventory[i]["quantity"] += item["quantity"]
				inventoryUpdated.emit()
				print("item added ", inventory)
				return true
			elif inventory[i] == null:
				inventory[i] = item
				print("adding %s " % item)
				inventoryUpdated.emit() #Tell UI to update itself
				return true
		return false

func removeItem(item):
	print("should be removing item....... ", item["quantity"])
	for i in range(inventory.size()): #check each spot in global array
		if inventory[i] != null and inventory[i]["itemID"] == item["itemID"]:
			if inventory[i]["quantity"] > item["quantity"]:
				inventory[i]["quantity"] -= item["quantity"]
				print("Quantity left after one picked ", inventory[i]["quantity"])
				if inventory[i]["quantity"] == 0:
					inventory[i] = null
			elif inventory[i]["quantity"] == item["quantity"]:
				print("Remove item entirely")
				inventory[i] = null
			inventoryUpdated.emit()
			break

func increaseInventorySize():
	inventoryUpdated.emit()



# Check player inventory for seeds
func checkSeeds(type):
	var seedsInv:Array = []
	for i in range(inventory.size()): #check each spot in global array
		if inventory[i] != null and inventory[i]["type"] == type:
			#print("you have a ", type) 
			seedsInv.push_back(inventory[i])
	return seedsInv



# *********************************************************************
# *********************   Move Items Logic STARTED *************************
# *********************************************************************

# TODO: Make it pick up the whole stack, not just one.
func pickUpItem(item):
	print("Inside PICKUP ITEM you have ", item)
	
	if Input.is_key_pressed(KEY_SHIFT) and item["quantity"] > 1:
		held_item = item.duplicate()
		held_item["quantity"] = 1
		print("Held item details after duplication ", held_item["quantity"])
		
		item["quantity"] -= 1
		if item["quantity"] == 0:
			removeItem(item)
		else:
			inventoryUpdated.emit()
	else:
		held_item = item.duplicate()
		print("Held item details after duplication ", held_item["quantity"])
		removeItem(item)
		
	is_holding_item = true
	remove_drag_preview()
	dragPreview = create_drag_preview(held_item)
	#print("Drag preview position: ", dragPreview.position)
	inventoryUpdated.emit()


func placeItem(item, slot_index: int = -1):
	print("is there something in my hand? ", held_item)
	if slot_index >= 0:
		var existing_item = inventory[slot_index]
		print("Existing item is ***** ", existing_item)
		print("Current item is ", item)
		if existing_item != null and existing_item["itemID"] == item["itemID"]:
			# Merge stacks
			existing_item["quantity"] += item["quanitity"]
			inventoryUpdated.emit()
		else:
			inventory[slot_index] = item
	else:
		addItem(item)

	is_holding_item = false
	
	remove_drag_preview()
	inventoryUpdated.emit()


# Swaps currently held item and the target slot item
func swapItems(target_slot_item, slot_index):
	# Save the currently held item to swap
	var temp_item = held_item
	placeItem(temp_item, slot_index)
	#print("Inside swap items, temp_item is now ", temp_item)
	held_item = target_slot_item #pick up target item in hand
	#print("Inside swap items, you should now be holding ", held_item)
	
	remove_drag_preview()
	dragPreview = create_drag_preview(target_slot_item)
	
	is_holding_item = true
	#inventoryUpdated.emit()
	
	
	inventoryUpdated.emit()
	
func clear_held_item():
	held_item = null
	is_holding_item = false
	remove_drag_preview()

func clear_slot(slot_index: int):
	inventory[slot_index] =  null
	inventoryUpdated.emit()
	print("Cleared slot", slot_index)

func update_inventory_slot(slot_index: int, item: Dictionary):
	inventory[slot_index] = item
	inventoryUpdated.emit() # Only trigger once when the slot update is done

func create_drag_preview(item) -> TextureRect:
	# Create drag preview
	print("Preview should be happening")
	dragPreview = TextureRect.new()
	dragPreview.texture = item["texture"]
	dragPreview.custom_minimum_size = Vector2(25,25)
	dragPreview.modulate.a = 0.7
	dragPreview.z_index = 99
	dragPreview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#dragPreview.visible = true
	# Show the item quantity on the drag preview
	if item["quantity"] > 1:
		var quantity_label = Label.new()
		quantity_label.text = "x%s" % item["quantity"]
		#quantity_label.rect_min_size = Vector2(25, 25)
		dragPreview.add_child(quantity_label)
	
	
	Inventory.add_child(dragPreview)
	var mouse_pos = get_viewport().get_mouse_position()
	#var local_mouse_pos = Inventory.get_global_transform_with_canvas().affine_inverse().xform(mouse_pos)
	dragPreview.position = mouse_pos
	return dragPreview


func remove_drag_preview():
	if dragPreview:
		dragPreview.queue_free()
		dragPreview = null
