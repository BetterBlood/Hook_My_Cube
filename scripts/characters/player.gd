extends Creature

class_name Player

const SPEED = 7.0
const JUMP_VELOCITY = 9
@onready var head := $Head
@onready var camera := $Head/Camera3D
@onready var elbow: Marker3D = $Elbow
@onready var rune_spot: Marker3D = $RuneSpot
@onready var ray_cast_3d: RayCast3D = $Head/RayCast3D

const SENSITIVITY = 0.07
var right_stick_sensitivity_h = 4
var right_stick_sensitivity_v = 4
var directionnalInputs = Vector3(0,0,0)

var JOY_DEADZONE:= 0.1

var godMode : bool
@export var godModeSpeedMultiplier = 5
@onready var collisionShape := $CollisionShape3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var joystick_v_event: InputEventJoypadMotion
var joystick_h_event: InputEventJoypadMotion

const SPHERE = preload("res://addons/polyrinthe/sphere.tscn") # DEBUG

var xp_to_lvl_up:float = 10

var rune: Rune

var grapple: Grapple

func _ready():
	super._ready()
	godMode = true
	collisionShape.disabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var fire_rune = FireRune1.new(self)
	fire_rune.projectile_layer_to_hit = 5
	rune = RuneUpgradeDamage.new(fire_rune, 2)
	rune = RuneUpgradeBounce.new(rune)
	rune = RuneUpgradePerforation.new(rune)
	rune = RuneUpgradeStatusEffectChance.new(rune, 1.0)
	
	layer = 2
	
	grapple = Grapple.new()
	grapple.set_creature_owner(self)
	grapple.position = $GrapplinPosition.position
	add_child(grapple)


func _input(event):
	# Checking right analog stick input for "mouse look"
	if event is InputEventJoypadMotion:
		if event.get_axis() == 3:
			joystick_v_event = event
		if event.get_axis() == 2:
			joystick_h_event = event


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta):
	if Input.is_action_just_pressed("attack"):
		#print("orphan:")
		#print_orphan_nodes() # DEBUG
		#print("---")
		
		ray_cast_3d.collision_mask = 7
		ray_cast_3d.target_position = Vector3(0, 0, -100)
		ray_cast_3d.force_raycast_update()
		var destination = Vector3()
		
		if ray_cast_3d.is_colliding():
			destination = ray_cast_3d.get_collision_point()
		else:
			$Head/RayCast3D/Marker3D.position = ray_cast_3d.target_position
			destination = $Head/RayCast3D/Marker3D.global_position
		
		#print(rune.get_data_to_performe_attaque().projectile_damage)
		rune.light_attack(destination, rune.get_data_to_performe_attaque())
		#print("rune save infos: ", rune.get_save_infos())
		rune = RuneUpgradeDamage.new(rune)
		rune = RuneUpgradeSpeed.new(rune)
	
		#var sphere = SPHERE.instantiate()
		#get_parent().add_child(sphere)
		#sphere.position = destination
		#sphere.scale = Vector3(0.2, 0.2, 0.2)
	
	if Input.is_action_just_pressed("grapple"):
		ray_cast_3d.collision_mask = grapple.get_collision_mask()
		ray_cast_3d.target_position = Vector3(0, 0, -grapple.get_distance())
		ray_cast_3d.force_raycast_update()
		var destination = Vector3()
		var hit: bool
		
		if ray_cast_3d.is_colliding():
			destination = ray_cast_3d.get_collision_point()
			hit = true
		else:
			$Head/RayCast3D/Marker3D.position = ray_cast_3d.target_position
			destination = $Head/RayCast3D/Marker3D.global_position
			hit = false
		
		grapple.shoot(destination, hit)
	
	if Input.is_action_just_released("grapple"):
		grapple.cancel_grab()
	
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
		velocity.y -= gravity * delta * 2

	directionnalInputs = Vector3(0,0,0)
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y += JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	directionnalInputs.x = input_dir.x
	directionnalInputs.z = input_dir.y
	
	var vertical = Input.get_axis("down", "up")
	directionnalInputs.y = vertical
	
	var direction = (get_global_transform().basis * directionnalInputs).normalized()
	
	if direction.x:
		if grapple.is_dragging:
			velocity.x += direction.x * (health_component.speed/2) * (godModeSpeedMultiplier if godMode else 1)
		else:
			velocity.x = direction.x * health_component.speed * (godModeSpeedMultiplier if godMode else 1)
	else:
		velocity.x = move_toward(velocity.x, 0, health_component.speed)
		
	if direction.z:
		if grapple.is_dragging:
			velocity.z += direction.z * (health_component.speed/2) * (godModeSpeedMultiplier if godMode else 1)
		else:
			velocity.z = direction.z * health_component.speed * (godModeSpeedMultiplier if godMode else 1)
	else:
		velocity.z = move_toward(velocity.z, 0, health_component.speed)
	
	if godMode:
		if direction.y:
			velocity.y = direction.y * health_component.speed * godModeSpeedMultiplier
		else:
			velocity.y = move_toward(velocity.y, 0, health_component.speed)
	
	move_and_slide()


func _on_player_area_3d_body_entered(body: Node3D) -> void:
	print("_on_player_area_3d_body_entered: ", body)


func get_type() -> Enums.DamageType:
	return Enums.DamageType.FIRE # TODO : get active rune type


func get_fire_projectile_spot() -> Marker3D:
	return rune_spot
