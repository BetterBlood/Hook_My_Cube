extends RuneUpgrade

class_name RuneUpgradeStatusEffectChance


func _init(rune: Rune, value: float = 0.01) -> void:
	super._init(rune)
	rune_resource.projectile_status_effect_chance = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeStatusEffectChance:" + \
			str(rune_resource.projectile_status_effect_chance)
