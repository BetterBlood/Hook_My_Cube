extends RuneUpgrade

class_name RuneUpgradeSpeed


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_speed = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeSpeed", "value": rune_resource.projectile_speed})
	return dico
