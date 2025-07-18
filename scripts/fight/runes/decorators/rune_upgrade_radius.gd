extends RuneUpgrade

class_name RuneUpgradeRadius


func _init(rune: Rune, lvl: RuneUpgrade.UpgradeLevel = RuneUpgrade.UpgradeLevel.ONE) -> void:
	super._init(rune)
	upgrade_lvl = lvl
	rune_resource.projectile_radius = VALUES_FOR_RADIUS[lvl]


func _to_string() -> String:
	return str(RuneUpgrade.RuneUpgradeType.keys()[7])
