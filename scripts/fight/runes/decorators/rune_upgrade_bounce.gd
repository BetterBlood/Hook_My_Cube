extends RuneUpgrade

class_name RuneUpgradeBounce


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_bounce_count = int(value)


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeBounce:" + \
			str(rune_resource.projectile_bounce_count)
