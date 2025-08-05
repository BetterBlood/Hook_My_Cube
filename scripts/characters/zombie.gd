extends Enemy

class_name Zombie

const SPEED:float = 3.0
@onready var navigation_agent_3d: NavigationAgent3D = $Navigation/NavigationAgent3D
var target: Creature
var base_position
var is_attacking: bool = false
var player_at_range: bool = false

func _ready() -> void:
	super._ready()
	
	if is_in_lobby:
		health_component._health_regen_per_sec = 1.0
	
	health_component._armor = 0.0
	health_component._penetration_resistance = 0.0
	health_component._max_speed = SPEED
	health_component.speed = SPEED 

func _physics_process(delta: float) -> void:
	if not base_position:
		$Navigation/UpdateNavigation.stop()
	elif $Navigation/UpdateNavigation.is_stopped():
		$Navigation/UpdateNavigation.start()
	
	var tmp_y_velocity = velocity.y 
	var direction = Vector3()
	if target or not navigation_agent_3d.is_navigation_finished():
		direction = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * health_component.speed, delta * 10)
	
	
	if player_at_range:
		velocity = Vector3()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 4
		#base_position = null
		velocity.y += tmp_y_velocity  * delta * 4
	move_and_slide()

func compute_path() -> void:
	#print("compute_path: ", base_position, ", target: ", target)
	if target:
		#print(target)
		navigation_agent_3d.target_position = target.global_position
	elif base_position:
		navigation_agent_3d.target_position = base_position

func _on_enemy_area_3d_body_entered(_body: Node3D) -> void:
	#print("enemy collide with: ", _body, ", groups: ", _body.get_groups())
	if not base_position and not _body.is_in_group("Player"):
		base_position = global_position
		#print(self, " set base_position to: ", base_position)
	elif _body.is_in_group("Player"):
		var creature = (_body as Creature)
		if 	creature and creature.has_method("get_health_component") and \
			creature.has_method("take_damage"):
				creature.take_damage(damage, get_type(), armor_pen)


func _on_update_navigation_timeout() -> void:
	compute_path()


func _on_chase_area_area_entered(area: Area3D) -> void:
	#print("_on_chase_area_area_entered")
	target = area.get_parent()


func _on_release_chase_area_area_exited(area: Area3D) -> void:
	#print("_on_release_chase_area_area_exited")
	if target == area.get_parent():
		target = null


func _on_attack_area_area_entered(_area: Area3D) -> void:
	player_at_range = true
	try_attack()


func _on_attack_area_area_exited(_area: Area3D) -> void:
	player_at_range = false


func try_attack() -> void:
	if player_at_range and !is_attacking:
		is_attacking = true
		$AnimationPlayer.play("attack")

func recover_after_attaque() -> void:
	$AnimationPlayer.play("recover")

func end_attack() -> void:
	is_attacking = false
	await get_tree().create_timer(0.3).timeout
	try_attack()
