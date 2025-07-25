extends Rune

class_name NormalRune1

const NORMAL_PROJECTILE_MAT = preload("res://materials/projectiles/normal_projectile.tres")

func _init(parent: Node3D) -> void:
	super._init(parent)
	
	active_mat = NORMAL_PROJECTILE_MAT
	
	#print("_init de NormalRune1: ", self)
	
	projectile_scene = preload("res://scenes/fight/projectiles/normal_projectile.tscn")
	
	cooldown = 2.0
	
	# TODO: load from file for rune with id 0 or name NormalRune1
	rune_resource.cooldown_reduction = 0.0
	rune_resource.projectile_perforation_count = 0
	rune_resource.projectile_bounce_count = 0
	rune_resource.projectile_penetration = 0.0
	rune_resource.projectile_damage = 5.0
	rune_resource.projectile_speed = 14.0
	rune_resource.projectile_status_effect_chance = 0.0
	rune_resource.projectile_radius = 0.25
	rune_resource.projectile_effect_duration = 0.0
	rune_resource.projectile_effect_area_range_transmission = 0.0


func get_rune_id() -> int:
	return 0


func get_damage_type() -> Enums.DamageType:
	return Enums.DamageType.NORMAL
