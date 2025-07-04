extends RuneUpgrade

class_name RuneUpgradePenetration


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_penetration = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradePenetration:" + \
			str(rune_resource.projectile_penetration)
