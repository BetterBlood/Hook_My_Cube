extends RuneUpgrade

class_name RuneUpgradePenetration


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_penetration = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradePenetration", "value": rune_resource.projectile_penetration})
	return dico
