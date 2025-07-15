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

var active_rune: Rune
var second_rune: Rune

var grapple: Grapple

var current_player_name: String = "Peter"
var gold: int = 0
var xp_to_lvl_up:float = 10 # TODO: compute in function of lvl


func _ready():
	super._ready()
	#print("player::_ready current_player_name: " + current_player_name)
	godMode = true
	collisionShape.disabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	active_rune = FireRune1.new(self) #TODO: init the player with the normal rune
	active_rune.projectile_layer_to_hit = 5
	active_rune = RuneUpgradeDamage.new(active_rune, 2) # DEBUG
	active_rune = RuneUpgradeBounce.new(active_rune) # DEBUG
	active_rune = RuneUpgradePerforation.new(active_rune) # DEBUG
	active_rune = RuneUpgradeStatusEffectChance.new(active_rune, 1.0) # DEBUG
	
	layer = 2
	
	grapple = Grapple.new()
	grapple.set_creature_owner(self)
	grapple.position = $GrapplinPosition.position
	add_child(grapple)


func initialize_player(meta_data, game_data, current_maze: Maze) -> void:
	if meta_data == null:
		push_error("No meta data for player initialisation")
		return 
	current_player_name = meta_data["current_player_name"]
	
	# meta data:
	active_rune = Rune.create_rune_with_id(meta_data["equiped_rune_lobby"], self)
	health_component.set_up_perm_with_data(meta_data["health_component_upgrades"])
	
	#progression data
	if game_data == null:
		print("while initialize_player: no game data")
		return
	
	if current_maze == null:
		push_error("while initialize_player: current_maze null, progression load failed")
		return
	
	if meta_data["current_player_name"] != game_data["current_player_name"]:
		push_warning("Player game progression initialisation may failed: player names are inconsistant")
	
	position = current_maze.get_position_for_player_save_point(int(game_data["save_spot_id"]))
	gold = game_data["gold"]
	health_component.health = game_data["hp"]
	lvl = game_data["lvl"]
	#TODO : initialise xp_to_lvl_up based on lvl
	xp = game_data["xp"]
	
	var rune1_data = game_data["runes"][0]
	var rune2_data = game_data["runes"][1] if len(game_data["runes"][1]) > 2 else null
	
	active_rune = Rune.create_rune(rune1_data, self) # this override meta_data active_rune
	second_rune = Rune.create_rune(rune2_data, self)
	
	health_component.set_up_temp_with_data(game_data["health_component_upgrades"])
	grapple.set_up_with_data(game_data["grappin_upgrades"])


func save_progression(save_point_id: int = 0) -> void:
	var save_file = FileAccess.open("user://" + current_player_name + "/progression.save", FileAccess.WRITE)
	
	var save_dict = {
		"current_player_name" : current_player_name,
		"save_spot_id" : save_point_id,
		"gold" : gold,
		"hp" : health_component.health,
		"lvl" : lvl,
		"xp" : xp,
		"runes" : 
			[
				active_rune.get_save_infos(),
				second_rune.get_save_infos() if second_rune else {}
			],
		"health_component_upgrades" : health_component.get_temp_data(),
		"grappin_upgrades" : # [0:range, 1:boost, 2:enemy, 3:ice_wall]
			grapple.get_data()
	}
	
	var json_string = JSON.stringify(save_dict)
	
	save_file.store_line(json_string)


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
		
		#print(active_rune.get_data_to_performe_attaque().projectile_damage)
		active_rune.light_attack(destination, active_rune.get_data_to_performe_attaque())
		
		#print("active_rune save infos: ", active_rune.get_save_infos())
		active_rune = RuneUpgradeDamage.new(active_rune)
		#active_rune = RuneUpgradeSpeed.new(active_rune)
	
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
		var hit2: bool = false
		
		if ray_cast_3d.is_colliding():
			destination = ray_cast_3d.get_collision_point()
			hit = true
		else:
			$Head/RayCast3D/Marker3D.position = ray_cast_3d.target_position
			destination = $Head/RayCast3D/Marker3D.global_position
			hit = false
		
		ray_cast_3d.collision_mask = 32768 - 1
		ray_cast_3d.target_position = Vector3(0, 0, -grapple.get_distance() - 1)
		ray_cast_3d.force_raycast_update()
		
		var dist_to_first_surface = Vector3()
		if ray_cast_3d.is_colliding():
			dist_to_first_surface = ray_cast_3d.get_collision_point() - position
			if dist_to_first_surface.length() + 0.0001 < (destination - position).length():
				destination = ray_cast_3d.get_collision_point()
				hit2 = true
				hit = false
		
		grapple.shoot(destination, hit, hit2)
	
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
	return active_rune.get_damage_type()


func _swap_runes() -> void:
	if second_rune:
		var tmp_rune = active_rune
		active_rune = second_rune
		second_rune = tmp_rune


func get_fire_projectile_spot() -> Marker3D:
	return rune_spot


func get_player_name() -> String:
	return current_player_name
