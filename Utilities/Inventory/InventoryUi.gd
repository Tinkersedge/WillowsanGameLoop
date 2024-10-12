extends Control
class_name InventoryUI


@onready var gridContainer = $GridContainer

var held_item: Dictionary = {}
var holding_item: bool = false


func _ready():
	InventoryManager.inventoryUpdated.connect(onInventoryUpdated)
	Signals.inventoryUpdated.connect(onInventoryUpdated)
	onInventoryUpdated()


func onInventoryUpdated():
	clearGridContainer()
	for item in InventoryManager.inventory:
		var slot = InventoryManager.inventory_slot_scene.instantiate()
		gridContainer.add_child(slot)
		if item != null:
			#print("should be setting item image")
			slot.set_item(item)
		else:
			slot.set_empty()

func clearGridContainer():
	while gridContainer.get_child_count() > 0:
		var child = gridContainer.get_child(0)
		gridContainer.remove_child(child)
		child.queue_free()
		
# *********************************************************************
# *********************   Move Items Logic STARTED *************************
# *********************************************************************

func get_slot_index(slot: InventorySlot) -> int:
	var all_slots = gridContainer.get_children()
	for i in range(all_slots.size()):
		if all_slots[i] == slot:
			return i
	return -1


func update_inventory(slot: InventorySlot) -> void:
	var index = gridContainer.get_children().find(slot)
	if index != -1:
		InventoryManager.inventory[index] = slot.current_item
		InventoryManager.inventoryUpdated.emit()
