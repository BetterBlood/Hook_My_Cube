extends Node3D

class_name Grapple

var ray_cast_3d: RayCast3D

var is_shooting: bool = false
var is_dragging: bool = false
var is_returning: bool = false
var cooldown_returning: float
var tmp_destination: Vector3 = Vector3()


var _distance: float = 30.0
var _defaul_mask: int = 16
var _enemy_mask: int = 4 # 4 means enemy, enemy need to defined it as 2 to catch the player
var _speed_boost: float = 1.2

var upgrades: Array[int] = [0, 0, 0, 0] # [range, boost, enemy, ice wall]


var grapple_owner: Creature

const SPHERE = preload("res://addons/polyrinthe/sphere.tscn") # DEBUG
var grappling_hook: Node
var tween: Tween
var _grapple_speed: float = 40.0
var _grapple_return_modifier: float = 1.0

const SPEED_EFFECT: PackedScene = preload("res://scenes/fight/statusEffects/speed_effect.tscn")

func _ready() -> void:
	grappling_hook = SPHERE.instantiate() # TODO: real grappling hook
	grappling_hook.scale = Vector3(0.05, 0.05, 0.05)
	add_child(grappling_hook)


func _process(delta: float) -> void:
	if is_dragging:
		#print("is_dragging")
		# compute direction
		var direction: Vector3 = grappling_hook.global_position - grapple_owner.global_position
		grapple_owner.velocity = direction.normalized() * delta * 1500
		# compute force
		# apply force to player
		# (redraw grapple line based in player position)
	elif is_returning:
		var dist = abs((grappling_hook.global_position - global_position).length())
		# TODO: set the return speed proportionnaly of the player speed cause the hook is too slow to return to user having hight speed
		if dist > 1:
			tween.stop()
			tween = get_tree().create_tween()
			cooldown_returning = dist / _grapple_speed * _grapple_return_modifier
			tween.tween_property(grappling_hook, "position", global_position, cooldown_returning)
			tween.finished.connect(_grapple_returned)


func get_distance() -> float:
	return _distance + upgrades[0] * 10


func get_collision_mask() -> int:
	return 	_defaul_mask + \
			_enemy_mask * (1 if upgrades[2] != 0 else 0) + \
			_defaul_mask * 2 * (1 if upgrades[3] != 0 else 0)


func set_creature_owner(new_owner: Creature) -> void:
	grapple_owner = new_owner


func upgrade_range() -> int:
	upgrades[0] += 1
	return upgrades[0]


func upgrade_boost() -> int:
	upgrades[1] += 1
	return upgrades[1]


func upgrade_enemy() -> int:
	upgrades[2] = 1
	return upgrades[2]


func upgrade_wall() -> int:
	upgrades[3] = 1
	return upgrades[3]


#	TODO ?: for being usable on moving target, need to pass the entity hited to reparent 
#	hook on the target (the raycast should provide this information) 
func shoot(destination: Vector3, hit: bool) -> void:
	if !_is_abble_to_shoot():
		return
	
	if hit:
		_grapple_return_modifier = 0.7
	else:
		_grapple_return_modifier = 1
	
	grappling_hook.reparent(get_parent().get_parent())
	
	#print("shoot")
	#print(destination)
	tmp_destination = destination
	
	#var sphere = SPHERE.instantiate()
	#get_parent().get_parent().add_child(sphere)
	#sphere.position = destination
	#sphere.scale = Vector3(0.2, 0.2, 0.2)
	
	_begin_shoot(hit)


func _is_abble_to_shoot() -> bool:
	#print("is_dragging, is_returning, is_shooting: ", is_dragging, is_returning, is_shooting)
	return !(is_dragging or is_returning or is_shooting)


func _begin_shoot(hit: bool) -> void:
	#print("_begin_shoot hit: ", hit)
	is_shooting = true
	
	#(Should be useless, but prevent shooting bug in case of incoherent positions)
	grappling_hook.position = global_position
	
	tween = get_tree().create_tween()
	tween.tween_property(
		grappling_hook, "position", tmp_destination, 
		abs((tmp_destination - global_position).length()) / _grapple_speed)
	tween.finished.connect(_begin_traction.bind(hit))


func _begin_traction(hit: bool) -> void:
	#print("_begin_traction")
	is_shooting = false
	
	if !hit or is_returning:
		if !is_returning:
			_begin_returning()
		#print("_begin_traction::aborted")
		return
	
	is_dragging = true
	grapple_owner.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING


func cancel_grab() -> void:
	#print("cancel_grab")
	if _is_abble_to_shoot() or is_returning:
		return
	
	grapple_owner.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED 
	if is_dragging && SPEED_EFFECT != null:
		#print("was dragging -> applying boost")
		# apply boost
		grapple_owner.velocity = Vector3.UP * 15
		
		#print(area.get_parent().has_method("can_host_status_effect"))
		if 		grapple_owner.has_method("can_host_status_effect"):
			var new_id = StatusEffectId.get_next_id() 
			if grapple_owner.can_host_status_effect(new_id):
				grapple_owner.add_effect_id(new_id)
				
				var effect_instance = SPEED_EFFECT.instantiate()
				effect_instance.effect_id = new_id
				effect_instance.same_effect = null
				effect_instance.cooldown = 3.0
				effect_instance.value = _speed_boost + 0.3 * upgrades[1]
				effect_instance.target = grapple_owner
				effect_instance.total_duration = 3.0
				effect_instance.total_duration_fixe = 3.0
				effect_instance.effect_area_range_transmission = 0
				grapple_owner.add_child(effect_instance)
	
	elif is_shooting:
		tween.stop()
	
	is_dragging = false
	is_shooting = false
	_begin_returning()


func _begin_returning() -> void:
	#print("_begin_returning")
	is_returning = true


func _grapple_returned() -> void:
	#print("_grapple_returned")
	is_returning = false
	tmp_destination = Vector3()
	grappling_hook.reparent(self)
	grappling_hook.position = Vector3()
