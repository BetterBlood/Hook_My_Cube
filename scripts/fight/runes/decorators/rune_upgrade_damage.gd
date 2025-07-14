extends RuneUpgrade

class_name RuneUpgradeDamage


func _init(rune: Rune, value: float = 1) -> void:
	super._init(rune)
	#print("_init de RuneUpgradeDamage: ", self)
	rune_resource.projectile_damage = value


func get_save_infos() -> Dictionary:
	var dico = super.get_save_infos()
	dico["rune_upgrades"].append({"type" : "RuneUpgradeDamage", "value": rune_resource.projectile_damage})
	return dico
