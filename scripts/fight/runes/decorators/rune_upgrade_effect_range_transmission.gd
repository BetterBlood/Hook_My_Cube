extends RuneUpgrade

class_name RuneUpgradeEffectRangeTransmission


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_effect_area_range_transmission = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeEffectRangeTransmission", "value": rune_resource.projectile_effect_area_range_transmission})
	return dico
