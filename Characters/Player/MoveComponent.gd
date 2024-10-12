extends Node

#Movement Related Variables
@export var walkSpeed = 750.0
@export var runSpeed = 1100.0
@export var jumpForce = -1200.0
@export_range(0,5) var floorSnap = 5.0
@export_range(0,1) var acceleration = 0.1
@export_range(0,1) var deceleration = 0.1
@export_range(0,1) var decelerateOnJumpRelease = 0.5

@export var player:CharacterBody2D
@export var animPlayer:AnimationPlayer
@onready var kevin = player.get_node("Kevin")

#Player Velocity
var velocity := Vector2.ZERO
var kevinScale := 1  # Used to flip the player sprite

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		velocity += player.get_gravity() * delta
	# if we press talk (E), actions the actionable
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		velocity.y = jumpForce
	
	if Input.is_action_just_released("up") and velocity.y < 0:
		velocity.y *= decelerateOnJumpRelease
	
	if velocity.x > 0 and player.is_on_floor():
		animPlayer.play("walk")
		kevin.scale.x = kevinScale * -1
	elif velocity.x < 0 and player.is_on_floor():
		animPlayer.play("walk")
		kevin.scale.x = kevinScale
	elif velocity.x == 0 and player.is_on_floor():
		animPlayer.play("idle")
	
	var speed
	if Input.is_action_pressed("run"):
		speed = runSpeed
	else:
		speed = walkSpeed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walkSpeed * deceleration)
	
	player.set_floor_snap_length(floorSnap)
	player.velocity = velocity
	player.move_and_slide()
