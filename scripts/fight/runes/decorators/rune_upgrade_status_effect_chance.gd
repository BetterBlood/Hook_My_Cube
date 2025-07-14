extends RuneUpgrade

class_name RuneUpgradeStatusEffectChance


func _init(rune: Rune, value: float = 0.01) -> void:
	super._init(rune)
	rune_resource.projectile_status_effect_chance = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeStatusEffectChance", "value": rune_resource.projectile_status_effect_chance})
	return dico
