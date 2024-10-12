extends CanvasLayer

@onready var inventory_ui = $Control/InventoryUI
@onready var trashCan = $InvTrashCan

var item_to_trash = null

func _ready() -> void:
	hide()
	Signals.thrownAway.connect(trashClicked)
	%YesButton.pressed.connect(tossIt)
	%NoButton.pressed.connect(keepIt)

func _process(_delta: float):
	# Press I to open inventory
	if Input.is_action_just_pressed("openInv") and Global.simpleUI == false:
		print("you clicked i")
		visible = !visible

func trashClicked():
	print("Trying to throw something away....")
	if InventoryManager.is_holding_item:
		print("Throw this away ", InventoryManager.held_item)
		item_to_trash = InventoryManager.held_item
		show_trash_popup()


func show_trash_popup():
	if item_to_trash and item_to_trash.has("texture"):
		%ItemPreview.texture = item_to_trash["texture"]
	else:
		%ItemPreview.texture = null
	
	$PopUp.show()
	


func keepIt():
	print("NOT Trying to toss this item ", item_to_trash)
	item_to_trash = null
	$PopUp.hide()

func tossIt():
	if item_to_trash != null:
		print("Trying to toss this item ", item_to_trash)
		InventoryManager.removeItem(item_to_trash)
		InventoryManager.clear_held_item()
		InventoryManager.inventoryUpdated.emit()
		$PopUp.hide()
		item_to_trash = null
