extends RuneUpgrade

class_name RuneUpgradeCooldownReduction


func _init(rune: Rune, value: float = 0.01) -> void:
	super._init(rune)
	rune_resource.cooldown_reduction = value


func get_save_infos() -> String:
	return 	super.get_save_infos() + "RuneUpgradeCooldownReduction:" + \
			str(rune_resource.cooldown_reduction)
