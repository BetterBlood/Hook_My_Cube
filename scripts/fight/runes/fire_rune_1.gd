extends Rune

class_name FireRune1


func _init(parent: Node3D) -> void:
	super._init(parent)
	
	#print("_init de FireRune1: ", self)
	
	projectile_scene = preload("res://scenes/fight/projectiles/fire_projectile.tscn")
	
	cooldown = 2.0
	
	# TODO: load from file for rune with id 1 or name FireRune1
	rune_resource.cooldown_reduction = 0.0
	rune_resource.projectile_perforation_count = 0
	rune_resource.projectile_bounce_count = 0
	rune_resource.projectile_penetration = 0.0
	rune_resource.projectile_damage = 5.0
	rune_resource.projectile_speed = 14.0
	rune_resource.projectile_status_effect_chance = 0.05
	rune_resource.projectile_radius = 0.25
	rune_resource.projectile_effect_duration = 2.0
	rune_resource.projectile_effect_area_range_transmission = 4


func get_rune_id() -> int:
	return 1


func get_damage_type() -> Enums.DamageType:
	return Enums.DamageType.FIRE
