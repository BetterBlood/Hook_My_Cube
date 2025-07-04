extends RuneUpgrade

class_name RuneUpgradeRadius


func _init(rune: Rune, value: float = 0.1) -> void:
	super._init(rune)
	rune_resource.projectile_radius = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeRadius:" + \
			str(rune_resource.projectile_radius)
