extends RuneUpgrade

class_name RuneUpgradeBounce


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	rune_resource.projectile_bounce_count = int(value)


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeBounce", "value": rune_resource.projectile_bounce_count})
	return dico
