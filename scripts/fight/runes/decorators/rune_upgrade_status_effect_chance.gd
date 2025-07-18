extends RuneUpgrade

class_name RuneUpgradeStatusEffectChance


func _init(rune: Rune, lvl: RuneUpgrade.UpgradeLevel = RuneUpgrade.UpgradeLevel.ONE) -> void:
	super._init(rune)
	upgrade_lvl = lvl
	rune_resource.projectile_status_effect_chance = VALUES_FOR_SATUS_EFFECT_CHANCE[lvl]


func _to_string() -> String:
	return str(RuneUpgrade.RuneUpgradeType.keys()[9])
