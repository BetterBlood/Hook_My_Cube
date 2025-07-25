extends Rune

class_name DebugRune

const DEBUG_PROJECTILE_MAT = preload("res://materials/projectiles/debug_projectile.tres")

func _init(parent: Node3D) -> void:
	super._init(parent)
	
	active_mat = DEBUG_PROJECTILE_MAT
	
	#print("_init de DebugRune: ", self)
	
	projectile_scene = preload("res://scenes/fight/projectiles/debug_projectile.tscn")
	
	cooldown = 2.0
	
	# TODO: don't load from file for rune with id -1 or name DebugRune cause it's debug man you know )> (o.O)
	rune_resource.cooldown_reduction = 0.0
	rune_resource.projectile_perforation_count = 1
	rune_resource.projectile_bounce_count = 1
	rune_resource.projectile_penetration = 1.0
	rune_resource.projectile_damage = 5.0
	rune_resource.projectile_speed = 14.0
	rune_resource.projectile_status_effect_chance = 1.0
	rune_resource.projectile_radius = 0.25
	rune_resource.projectile_effect_duration = 2.0
	rune_resource.projectile_effect_area_range_transmission = 27.5


func get_rune_id() -> int:
	return -1


func get_damage_type() -> Enums.DamageType:
	return Enums.DamageType.FIRE
