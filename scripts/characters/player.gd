extends Creature

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var head := $Head
@onready var camera := $Head/Camera3D
const SENSITIVITY = 0.07
var right_stick_sensitivity_h = 4
var right_stick_sensitivity_v = 4
var directionnalInputs = Vector3(0,0,0)

var JOY_DEADZONE:= 0.1

var godMode : bool
@export var godModeSpeedMultiplier = 15
@onready var collisionShape := $CollisionShape3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var joystick_v_event: InputEventJoypadMotion
var joystick_h_event: InputEventJoypadMotion

func _input(event):
	# Checking right analog stick input for "mouse look"
	if event is InputEventJoypadMotion:
		if event.get_axis() == 3:
			joystick_v_event = event
		if event.get_axis() == 2:
			joystick_h_event = event

func _ready():
	super._ready()
	godMode = true
	collisionShape.disabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	
	if Input.is_action_just_pressed("godMod"):
		godMode = !godMode
		if godMode:
			collisionShape.disabled = true
		else :
			collisionShape.disabled = false
	
	
	if joystick_h_event:
		if abs(joystick_h_event.get_axis_value()) > JOY_DEADZONE:
			rotate_y(deg_to_rad(-joystick_h_event.get_axis_value() * right_stick_sensitivity_h))
	if joystick_v_event:
		if abs(joystick_v_event.get_axis_value()) > JOY_DEADZONE:
			head.rotate_x(deg_to_rad(-joystick_v_event.get_axis_value() * right_stick_sensitivity_v))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	# Add the gravity.
	if not is_on_floor() && !godMode:
		velocity.y -= gravity * delta

	directionnalInputs = Vector3(0,0,0)
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	directionnalInputs.x = input_dir.x
	directionnalInputs.z = input_dir.y # oui c'est bien z qui correspond à y
	
	var vertical = Input.get_axis("down", "up")
	directionnalInputs.y = vertical
	
	var direction = (get_global_transform().basis * directionnalInputs).normalized()
	
	if direction.x:
		velocity.x = direction.x * SPEED * (godModeSpeedMultiplier if godMode else 1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction.z:
		velocity.z = direction.z * SPEED * (godModeSpeedMultiplier if godMode else 1)
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if godMode:
		if direction.y:
			velocity.y = direction.y * SPEED * godModeSpeedMultiplier
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func _on_player_area_3d_body_entered(body: Node3D) -> void:
	print("player collide with: ", body)
