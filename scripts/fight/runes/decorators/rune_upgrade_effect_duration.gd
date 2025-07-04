extends RuneUpgrade

class_name RuneUpgradeEffectDuration


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_effect_duration = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeEffectDuration:" + \
			str(rune_resource.projectile_effect_duration)
