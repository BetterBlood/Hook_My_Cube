extends Rune

class_name ElectricRune1

const ELECTRIC_PROJECTILE_MAT = preload("res://materials/projectiles/electric_projectile.tres")

func _init(parent: Node3D) -> void:
	super._init(parent)
	
	active_mat = ELECTRIC_PROJECTILE_MAT
	
	#print("_init de ElectricRune1: ", self)
	
	projectile_scene = preload("res://scenes/fight/projectiles/electric_projectile.tscn")
	
	cooldown = 1.5
	
	# TODO: load from file for rune with id 3 or name ElectricRune1
	rune_resource.cooldown_reduction = 0.0
	rune_resource.projectile_perforation_count = 1
	rune_resource.projectile_bounce_count = 0
	rune_resource.projectile_penetration = 1.0
	rune_resource.projectile_damage = 3.0
	rune_resource.projectile_speed = 16.0
	rune_resource.projectile_status_effect_chance = 0.05 # 0.05 default
	rune_resource.projectile_radius = 0.2
	rune_resource.projectile_effect_duration = 0.6
	rune_resource.projectile_effect_area_range_transmission = 10


func get_rune_id() -> int:
	return 3


func get_damage_type() -> Enums.DamageType:
	return Enums.DamageType.ELEC
