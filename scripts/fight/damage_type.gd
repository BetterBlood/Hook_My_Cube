extends Node

class_name Enums

enum DamageType {
	NORMAL,
	FIRE,
	PLANT,
	ELEC
}

static var damage_type_grid:Dictionary = {}

static func get_grid_modifier(att_type: Enums.DamageType, def_type: Enums.DamageType) -> float:
	print("att_type: ", Enums.DamageType.keys()[att_type], ", def_type: ", Enums.DamageType.keys()[def_type])
	
	return damage_type_grid[str(Enums.DamageType.keys()[att_type])][def_type]
