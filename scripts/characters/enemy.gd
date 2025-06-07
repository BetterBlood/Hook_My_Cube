extends Creature

class_name Enemy

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
@onready var navigation_agent_3d: NavigationAgent3D = $Navigation/NavigationAgent3D
var target: Creature
var base_position

func _ready() -> void:
	super._ready()
	

func _physics_process(delta: float) -> void:
	
	var direction = Vector3()
	if target or not navigation_agent_3d.is_navigation_finished():
		direction = (navigation_agent_3d.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * SPEED, delta * 10)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func compute_path() -> void:
	if target:
		print(target)
		navigation_agent_3d.target_position = target.global_position
	else:
		navigation_agent_3d.target_position = base_position

func _on_enemy_area_3d_body_entered(body: Node3D) -> void:
	print("enemy collide with: ", body)
	if not base_position:
		base_position = global_position


func _on_update_navigation_timeout() -> void:
	compute_path()


func _on_chase_area_area_entered(area: Area3D) -> void:
	print("_on_chease_area_area_entered")
	target = area.get_parent()


func _on_release_chase_area_area_exited(area: Area3D) -> void:
	print("_on_release_chase_area_area_exited")
	if target == area.get_parent():
		target = null
