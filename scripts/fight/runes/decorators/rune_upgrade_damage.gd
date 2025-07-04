extends RuneUpgrade

class_name RuneUpgradeDamage


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	#print("_init de RuneUpgradeDamage: ", self)
	rune_resource.projectile_damage = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeDamage:" + \
			str(rune_resource.projectile_damage)
