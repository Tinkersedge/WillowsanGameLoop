extends Area2D
class_name Doors

var atDoor: bool = false
var doorLocation:Vector2

# enum for different street names
enum CurrentStreet {MAIN, ARTS, FARM, FOOD, FESTIVAL}
# enum for door types, Outside going in, Inside going out, ...
enum DoorType {SUBWAY, OUT_IN, IN_OUT, IN_IN}

# exports for setting up each door
@export var doorType: DoorType
@export_file var destination:String = ""
# variables needed for outside going in
@export_group("Outside")
@export var currentStreet: CurrentStreet
#variables needed for In_In
@export_group("Inside")
@export var isMainDoor:bool = false
@export var isReturningDoor:bool = false

@onready var hint:Label = $Hint

func _ready() -> void:
	doorLocation = Vector2(self.global_position.x, 1657)
	TransportMgr.interiorSaveSpot = doorLocation

func _process(_delta:float) -> void:
	if atDoor == true and Input.is_action_just_pressed("interact"):
		handleInteraction()

func handleInteraction():
	pass
	match doorType:
		DoorType.SUBWAY:
			pass
		DoorType.IN_IN:
			if isReturningDoor == true:
				TransportMgr.interiorSaveSpot = doorLocation
			TransportMgr.changeRooms(destination)
		DoorType.IN_OUT:
			TransportMgr.goBuildToStreet(currentStreet)
		DoorType.OUT_IN:
			TransportMgr.insideLocation = doorLocation
			TransportMgr.goInside(destination)
		
# Show hint if player near door
func isPlayerNearDoor(is_near:bool):
	atDoor = is_near
	if is_near:
		hint.showHint(self.global_position + Vector2(40,40))
	else:
		hint.hideHint()



func _on_area_entered(_area: Area2D) -> void:
	isPlayerNearDoor(true)
func _on_area_exited(_area: Area2D) -> void:
	isPlayerNearDoor(false)
func _on_body_entered(_body: Node2D) -> void:
	isPlayerNearDoor(true)
func _on_body_exited(_body: Node2D) -> void:
	isPlayerNearDoor(false)
