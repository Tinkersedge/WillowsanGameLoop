@tool
extends CharacterBody2D

enum NPC_STATE {IDLE, WALK, TALK}

@export var npcName: String = ""
@export var npcChatID: String = ""
@export var moveSpeed: int = 300
@export var npcTexture: Texture
@export_range(0,5) var floorSnap = 5.0

var moveDirection : Vector2  = Vector2.ZERO
var currentState: NPC_STATE = NPC_STATE.IDLE
var randomSec: int
var playerHere: bool = false

func _ready():
	#$NPC.texture = npcTexture
	if not Engine.is_editor_hint():
		$NPC.texture = npcTexture
		#iconSprite.texture = item_resource.texture
	randomize()
	moveSpeed = randi_range(50, 300)
	currentState = NPC_STATE.IDLE
	#print("NPC has chosen direction ", moveDirection)
	Signals.questStateChanged.connect(checkForQuests)

func action():
	playerHere = true
	moveSpeed = 0
	checkForQuests()

func checkForQuests():
	if playerHere:
		# if UNLOCKED, COMPLETED, or ACTIVE quests, show quest button & !
		var validQuests = QuestMgr.get_valid_quests(npcName)
		if validQuests.size() > 0:
			%QuestIcon.play("active") # Show !
			%Quest.show() # Show Quest button on talk options
		else:
			%QuestIcon.play("idle") # No !
			%Quest.hide() # Hide quest button on talk options
		%InteractOptions.show()


func stopAction():
	playerHere = false
	moveSpeed = randi_range(50, 300)
	%InteractOptions.hide()


func _on_talk_pressed() -> void:
	#print("Wanna talk to me?")
	ChatMgr.startNPCchat(npcName, npcChatID)


func _on_quest_pressed() -> void:
	# Check and progress quests
	QuestMgr.progress_quests(npcName)
	




# ***********************************************************
# ****************** Random Movement - Delete Later
# ***********************************************************
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		$NPC.texture = npcTexture
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if currentState == NPC_STATE.IDLE:
		velocity.x = 0
	elif currentState == NPC_STATE.WALK:
		if position.x < 328:
			moveDirection.x = 1
		elif position.x > 5592:
			moveDirection.x = -1
		velocity.x = moveDirection.x * moveSpeed
	
	
	set_floor_snap_length(floorSnap)
	move_and_slide()



func selectNewDirection():
	moveDirection.x = randi_range(-1,1)
	#moveDirection = Vector2(
		#randi_range(-1,1),
		#0
	#)
	if moveDirection == Vector2(0,0):
		currentState = NPC_STATE.IDLE
	$Timer.start(randomTime())
	#print("new direction chosen ", moveDirection)

func pickNewState():
	if(currentState == NPC_STATE.IDLE):
		currentState = NPC_STATE.WALK
		selectNewDirection()
	elif(currentState == NPC_STATE.WALK):
		currentState = NPC_STATE.IDLE
		$Timer.start(randomTime())
	#print("picking new state, " , currentState)


func _on_timer_timeout() -> void:
	pickNewState()


func randomTime():
	randomSec = randi_range(0, 7)
	#print("randomtime has chosen ", randomSec)
	return randomSec
