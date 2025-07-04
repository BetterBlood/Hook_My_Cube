extends RuneUpgrade

class_name RuneUpgradePerforation


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_perforation_count = int(value)


func get_save_infos() -> String:
	return	super.get_save_infos() + "RuneUpgradePerforation:" + \
			str(rune_resource.projectile_perforation_count)
