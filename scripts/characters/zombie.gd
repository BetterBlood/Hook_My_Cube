extends Enemy

class_name Zombie

const SPEED:float = 3.0
@onready var navigation_agent_3d: NavigationAgent3D = $Navigation/NavigationAgent3D
var target: Creature
var base_position

func _ready() -> void:
	super._ready()
	
	health_component._health_regen_per_sec = 1.0
	health_component._armor = 2.0
	health_component._penetration_resistance = 0.5
	health_component._max_speed = SPEED
	health_component.speed = SPEED

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	if target or not navigation_agent_3d.is_navigation_finished():
		direction = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * health_component.speed, delta * 10)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	
	move_and_slide()

func compute_path() -> void:
	if target:
		#print(target)
		navigation_agent_3d.target_position = target.global_position
	elif base_position:
		navigation_agent_3d.target_position = base_position

func _on_enemy_area_3d_body_entered(body: Node3D) -> void:
	print("enemy collide with: ", body)
	if not base_position:
		base_position = global_position


func _on_update_navigation_timeout() -> void:
	compute_path()


func _on_chase_area_area_entered(area: Area3D) -> void:
	print("_on_chase_area_area_entered")
	target = area.get_parent()


func _on_release_chase_area_area_exited(area: Area3D) -> void:
	print("_on_release_chase_area_area_exited")
	if target == area.get_parent():
		target = null
