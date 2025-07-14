extends RuneUpgrade

class_name RuneUpgradeCooldownReduction


func _init(rune: Rune, value: float = 0.01) -> void:
	super._init(rune)
	rune_resource.cooldown_reduction = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeCooldownReduction", "value": rune_resource.cooldown_reduction})
	return dico
