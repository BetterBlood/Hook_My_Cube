extends Node

class_name Rune

# decorators attribute
var cooldown: float 
var rune_resource: RuneResource = RuneResource.new()

var projectile_scene: Resource

var projectile_layer_to_hit: int = 1
var projectile_source: Creature
var rune_spot: Marker3D

func _init(parent: Node3D) -> void:
	#print("_init de Rune: ", self)
	projectile_source = parent
	rune_spot = projectile_source.get_fire_projectile_spot()
	if rune_spot == null:
		push_warning("Rune shooting position not set, set to (0, 0, 0)")
		rune_spot = Marker3D.new()
		rune_spot.position = Vector3()
		add_child(rune_spot)


static func create_rune_with_id(id: int, parent: Node3D) -> Rune:
	match(id): # TODO: add case for all runes
		#-1:# TODO: debug rune
		#0: # TODO: normal rune
		1: return FireRune1.new(parent)
		_: push_warning("Rune id " + str(id) + " not recognized: FireRune1 used by default")
	
	return FireRune1.new(parent)


static func create_rune(rune_data, parent: Node3D) -> Rune:
	if !rune_data: return null
	 
	var rune: Rune = create_rune_with_id(int(rune_data["rune_id"]), parent)
	
	var upgrades = rune_data["rune_upgrades"]
	
	for upgrade in upgrades:
		rune = upgrade_rune(rune, upgrade["type"], upgrade["value"])
	
	return rune

static func upgrade_rune(rune: Rune, upgrade_name: String, value: int) -> Rune:
	match(upgrade_name):
		"RuneUpgradeBounce": return RuneUpgradeBounce.new(rune, value)
		"RuneUpgradeCooldownReduction": return RuneUpgradeCooldownReduction.new(rune, value)
		"RuneUpgradeDamage": return RuneUpgradeDamage.new(rune, value)
		"RuneUpgradeEffectDuration": return RuneUpgradeEffectDuration.new(rune, value)
		"RuneUpgradeEffectRangeTransmission": return RuneUpgradeEffectRangeTransmission.new(rune, value)
		"RuneUpgradePenetration": return RuneUpgradePenetration.new(rune, value)
		"RuneUpgradePerforation": return RuneUpgradePerforation.new(rune, value)
		"RuneUpgradeRadius": return RuneUpgradeRadius.new(rune, value)
		"RuneUpgradeSpeed": return RuneUpgradeSpeed.new(rune, value)
		"RuneUpgradeStatusEffectChance": return RuneUpgradeStatusEffectChance.new(rune, value)
		_: push_warning("Rune upgrade " + upgrade_name + " not recognized")
	return rune

func light_attack(destination: Vector3, rune_resource_for_projectile: RuneResource) -> void:
	#print(self, " ", rune_resource_for_projectile.projectile_damage)
	var projectile = projectile_scene.instantiate()
	
	projectile_source.get_parent().add_child(projectile)
	projectile.source = projectile_source
	projectile.global_position = rune_spot.global_position
	projectile.set_layers_to_hit(projectile_layer_to_hit)
	projectile.set_data(rune_resource_for_projectile)
	
	projectile.apply_impulse(
		(destination - rune_spot.global_position).normalized() * 
		rune_resource_for_projectile.projectile_speed, Vector3())


func heavy_attack(destination: Vector3) -> void:
	pass

func get_rune_id() -> int:
	return -1

func get_damage_type() -> Enums.DamageType:
	push_error("get_damage_type not implemented in ", self)
	assert(false, "Override of `get_damage_type()` needed in " + str(self))
	return Enums.DamageType.NORMAL

func get_data_to_performe_attaque() -> RuneResource:
	#print("get_data_to_performe_attaque()::Rune")
	return rune_resource


func get_save_infos() -> Dictionary:
	return {}
