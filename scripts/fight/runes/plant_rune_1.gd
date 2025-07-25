extends Rune

class_name PlantRune1

const PLANT_PROJECTILE_MAT = preload("res://materials/projectiles/plant_projectile.tres")

func _init(parent: Node3D) -> void:
	super._init(parent)
	
	active_mat = PLANT_PROJECTILE_MAT
	
	#print("_init de PlantRune1: ", self)
	
	projectile_scene = preload("res://scenes/fight/projectiles/plant_projectile.tscn")
	
	cooldown = 2.5
	
	# TODO: load from file for rune with id 2 or name PlantRune1
	rune_resource.cooldown_reduction = 0.0
	rune_resource.projectile_perforation_count = 0
	rune_resource.projectile_bounce_count = 1
	rune_resource.projectile_penetration = 0.0
	rune_resource.projectile_damage = 4.0
	rune_resource.projectile_speed = 12.0
	rune_resource.projectile_status_effect_chance = 0.05 # 0.05 default
	rune_resource.projectile_radius = 0.4
	rune_resource.projectile_effect_duration = 2.0
	rune_resource.projectile_effect_area_range_transmission = 7


func get_rune_id() -> int:
	return 2


func get_damage_type() -> Enums.DamageType:
	return Enums.DamageType.PLANT
