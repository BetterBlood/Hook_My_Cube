extends Enemy

class_name Tentacle

var can_rotate: bool = true
var is_attacking: bool = false
var on_knockback_area: bool = false
var player: Player
@onready var marker_3d: Marker3D = $Marker3D

const update_rotation: float = 0.05
var rotation_delay: float = 0.0

@onready var effect: MeshInstance3D = $Effect
var shader_mat: Material
var shader_mat_2: Material
var shader_mat_3: Material

@onready var default_material: MeshInstance3D = $"Sketchfab_Scene/Sketchfab_model/Collada visual scene group/Cube/defaultMaterial"
@onready var default_material_2: MeshInstance3D = $"Sketchfab_Scene/Sketchfab_model/Collada visual scene group/Cube/defaultMaterial2"
@onready var default_material_3: MeshInstance3D = $"Sketchfab_Scene/Sketchfab_model/Collada visual scene group/Cube/defaultMaterial3"
const BOSS_ON_FIRE_1 = preload("res://materials/shaders/boss_on_fire_1.tres")
const BOSS_ON_FIRE_2 = preload("res://materials/shaders/boss_on_fire_2.tres")
const BOSS_ON_FIRE_3 = preload("res://materials/shaders/boss_on_fire_3.tres")

func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("Player")
	health_component._max_health = 350
	health_component.health = health_component._max_health
	health_component._armor = 2.0
	health_component._penetration_resistance = 0.5
	health_component._max_speed = 50 # rotation speed
	health_component.speed = health_component._max_speed
	damage = 15 # TODO: balance !
	damage_type = Enums.DamageType.NORMAL # TODO: when water is added: change this to water damage type
	$AnimationPlayer.play("idle")
	
	attack_cd = 2.0
	id = -1
	



func _on_fire_effect(): # TODO: better fire animation
	#print("fire_effect")
	default_material.set_surface_override_material(0, BOSS_ON_FIRE_1)
	shader_mat = default_material.get_surface_override_material(0)
	
	default_material_2.set_surface_override_material(0, BOSS_ON_FIRE_2)
	shader_mat_2 = default_material_2.get_surface_override_material(0)
	
	default_material_3.set_surface_override_material(0, BOSS_ON_FIRE_3)
	shader_mat_3 = default_material_3.get_surface_override_material(0)
	
	shader_mat.set_shader_parameter("shader_parameter/dissolveSlider", 0.0)
	shader_mat_2.set_shader_parameter("shader_parameter/dissolveSlider", 0.0)
	shader_mat_3.set_shader_parameter("shader_parameter/dissolveSlider", 0.0)
	
	#effect.visible = true
	#shader_parameter/dissolveSlider
	var cd: float = StatusEffect.DEFAULT_COOLDOWN / 2
	var tween = get_tree().create_tween()
	tween.tween_property(shader_mat, "shader_parameter/dissolveSlider", 0.5, cd)
	tween.tween_property(shader_mat_2, "shader_parameter/dissolveSlider", 0.5, cd)
	tween.tween_property(shader_mat_3, "shader_parameter/dissolveSlider", 0.5, cd)
	
	var timer = get_tree().create_timer(cd)
	await timer.timeout
	##effect.visible = false
	#shader_mat.set_shader_parameter("shader_parameter/dissolveSlider", 0.0)
	#shader_mat_2.set_shader_parameter("shader_parameter/dissolveSlider", 0.0)
	#shader_mat_3.set_shader_parameter("shader_parameter/dissolveSlider", 0.0)
	
	
	default_material.set_surface_override_material(0, null)
	
	default_material_2.set_surface_override_material(0, null)
	
	default_material_3.set_surface_override_material(0, null)

func _physics_process(delta: float) -> void:
	if can_rotate:
		current_cd += delta
		if is_attacking:
			current_cd = 0.0
		
		if current_cd >= attack_cd:
			is_attacking = true
			current_cd = 0.0
			attack_cd = randf_range(0.5, 3.0)
			$AnimationPlayer.play("attack")
		#rotation_delay += delta
		#if rotation_delay >= update_rotation:
			#rotation_delay = 0
			#
			#var player_direction = player.global_position - global_position
			#var current_direction = marker_3d.global_position - global_position
			#rotation += rotation.lerp(
				#Vector3(
					#0, 
					#(current_direction).signed_angle_to(player_direction, Vector3.UP), 
					#0
				#), 
				#0.5
			#)
		
		var to_player = player.global_transform.origin - global_transform.origin
		to_player.y = 0
		to_player = to_player.normalized()
		
		var current_y = rotation.y
		var desired_y = atan2(to_player.x, to_player.z)
		var new_y = lerp_angle(current_y, desired_y, 0.1)
		#print(new_y)
		rotation.y = new_y
		
		
		#print(atan2(get_floor_angle()))
		#var player_simple_position: Vector3 = Vector3(player.position.x, 0, player.position.z).normalized() * 100
		#var basique_simple_position: Vector3 = Vector3(marker_3d.position.x, 0, marker_3d.position.z).normalized() * 100
		#var tmp = basique_simple_position.lerp(player_simple_position, clampf(delta * health_component.speed, 0, 1))
		#var position_test = lerp(Vector3(marker_3d.position.x, 0, marker_3d.position.z).normalized(), player_simple_position, clampf(delta * health_component.speed, 0, 1)) 
		#transform = transform.looking_at(Vector3() - player_simple_position, Vector3.UP)
		#rotation_degrees.y +=  health_component.speed * delta
		#var player_direction: Vector3 = player.global_position - global_position
		#player_direction.y = 0
		##if player_direction.length_squared() > 0.001:
			##var target_rotation = Vector3(0, rotation.signed_angle_to(player_direction, Vector3.UP), 0)
			##rotation.y = lerp_angle(rotation.y, target_rotation.y, health_component.speed * delta)
			#
		#var current_direction = marker_3d.global_position - global_position
		##print("current_direction: ", current_direction, ", player_direction: ", player_direction)
		##print((current_direction).signed_angle_to(player_direction, Vector3.UP))
		#
		#var target_rotation = global_transform.looking_at(player_direction, Vector3.UP).basis.get_euler()
		##var current_rotation = marker_3d.global_transform.basis.get_euler()
		##var current_direction: Vector3 = marker_3d.global_position - global_position
		#current_direction.y = 0
		#var current_rotation = global_transform.looking_at(current_direction, Vector3.UP).basis.get_euler()
		#var rotation_speed = delta * health_component.speed
		#print(current_rotation, target_rotation)
		#var new_rotation = Vector3(#0, target_rotation.y, 0)
			#lerp_angle(current_rotation.x, 0, rotation_speed),
			#lerp_angle(current_rotation.y, target_rotation.y, rotation_speed),
			#lerp_angle(current_rotation.z, 0, rotation_speed)
		#)
		#
		#global_transform.basis = Basis.from_euler(new_rotation)
		#print(new_rotation)
		
	
	#if Input.is_action_just_pressed("attack"):
		#var player_direction = player.global_position - global_position
		#var current_direction = marker_3d.global_position - global_position
		#print("current_direction: ", current_direction, ", player_direction: ", player_direction)
		#print(rad_to_deg((current_direction).signed_angle_to(player_direction, Vector3.UP)))
		#print(
			#rotation.lerp(
				#Vector3(
					#0, 
					#(current_direction).signed_angle_to(player_direction, Vector3.UP), 
					#0
				#), 
				#clampf(delta * health_component.speed, 0, 1)
			#)
		#)
		#rotation += rotation.lerp(
			#Vector3(
				#0, 
				#(current_direction).signed_angle_to(player_direction, Vector3.UP), 
				#0
			#), 
			#1
		#)


func _attack_end() -> void:
	can_rotate = true
	is_attacking = false
	$AnimationPlayer.play("idle")

func _attack_callibrate() -> void:
	can_rotate = false

func _on_player_listener_area_entered(area: Area3D) -> void:
	#print("player hit: ", area.get_parent())
	if area.get_parent().is_in_group("Player"):
		var creature = (area.get_parent() as Creature)
		if 	creature and creature.has_method("get_health_component") and \
			creature.has_method("take_damage"):
				creature.take_damage(damage, get_type(), armor_pen)

func _attack_touch_ground() -> void:
	var direction: Vector3 = player.position - position
	direction.y = 0
	#print(direction)
	if on_knockback_area:
		#print("too close -> apply velocity")
		player.velocity += direction.normalized() * 120


func _on_knock_back_area_area_entered(_area: Area3D) -> void:
	on_knockback_area = true


func _on_knock_back_area_area_exited(_area: Area3D) -> void:
	on_knockback_area = false


func _death_sequence() -> void:
	# TODO: animations
	
	is_dead.emit(id) # notify the death (need an id to emit, but isn't used for bosses)
	
	queue_free()
