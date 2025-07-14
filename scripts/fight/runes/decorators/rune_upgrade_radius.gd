extends RuneUpgrade

class_name RuneUpgradeRadius


func _init(rune: Rune, value: float = 0.1) -> void:
	super._init(rune)
	rune_resource.projectile_radius = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeRadius", "value": rune_resource.projectile_radius})
	return dico
