extends RuneUpgrade

class_name RuneUpgradeEffectRangeTransmission


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_effect_area_range_transmission = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeEffectRangeTransmission:" + \
			str(rune_resource.projectile_effect_area_range_transmission)
