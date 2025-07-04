extends RuneUpgrade

class_name RuneUpgradeSpeed


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_speed = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeSpeed:" + \
			str(rune_resource.projectile_speed)
