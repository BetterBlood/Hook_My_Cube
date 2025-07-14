extends RuneUpgrade

class_name RuneUpgradeEffectDuration


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_effect_duration = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeEffectDuration", "value": rune_resource.projectile_effect_duration})
	return dico
