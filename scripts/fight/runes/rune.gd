extends Node

class_name Rune

# decorators attribute
var cooldown: float 
var rune_resource: RuneResource = RuneResource.new()

var projectile_scene: Resource

var projectile_layer_to_hit: int = 1
var projectile_source: Creature
var rune_spot: Marker3D

static var NBR_UPGRADES: int = 10

const RUNE_VISUAL_IDENTIFIER = preload("res://scenes/fight/runes/visualIndicators/rune_visual_identifier.tscn")
var visual_rune: Node3D
var active_mat: StandardMaterial3D

func _init(parent: Node3D) -> void:
	#print("_init de Rune: ", self)
	projectile_source = parent
	rune_spot = projectile_source.get_fire_projectile_spot()
	if rune_spot == null:
		push_warning("Rune shooting position not set, set to (0, 0, 0)")
		rune_spot = Marker3D.new()
		rune_spot.position = Vector3()
		#get_parent().add_child(rune_spot)


func activate() -> void:
	for child in get_rune_spot().get_children():
		child.queue_free()
	visual_rune = RUNE_VISUAL_IDENTIFIER.instantiate()
	visual_rune.scale = Vector3(0.2, 0.2, 0.2)
	get_rune_spot().add_child(visual_rune)
	visual_rune.get_child(0).mesh.material = get_active_mat()

func get_rune_spot() -> Marker3D:
	return rune_spot
	
func get_active_mat() -> StandardMaterial3D:
	return active_mat

static func create_rune_with_id(id: int, parent: Node3D) -> Rune:
	match(id): # TODO: add case for all runes
		-1: return DebugRune.new(parent)
		0: return NormalRune1.new(parent)
		1: return FireRune1.new(parent)
		2: return PlantRune1.new(parent)
		3: return ElectricRune1.new(parent)
		_: push_warning("Rune id " + str(id) + " not recognized: FireRune1 used by default")
	
	return FireRune1.new(parent)


static func create_rune(rune_data, parent: Node3D) -> Rune:
	if !rune_data: return null
	 
	var rune: Rune = create_rune_with_id(int(rune_data["rune_id"]), parent)
	
	var upgrades = rune_data["rune_upgrades"]
	
	for upgrade in upgrades:
		rune = upgrade_rune(rune, upgrade["type"], upgrade["level"])
	
	return rune


static func upgrade_rune(rune: Rune, upgrade_name: String, level: int) -> Rune:
	print("Rune::upgrade_rune, rune: ", rune.get_save_infos(), ", upgrade_name: ", upgrade_name, ", lvl: ", str(level))
	match(upgrade_name):
		"BOUNCE":
			return RuneUpgradeBounce.new(rune, level)
		"COOLDOWN_REDUCTION":
			return RuneUpgradeCooldownReduction.new(rune, level)
		"DAMAGE":
			return RuneUpgradeDamage.new(rune, level)
		"EFFECT_DURATION":
			return RuneUpgradeEffectDuration.new(rune, level)
		"EFFECT_RANGE":
			return RuneUpgradeEffectRangeTransmission.new(rune, level)
		"PENETRATION":
			return RuneUpgradePenetration.new(rune, level)
		"PERFORATION":
			return RuneUpgradePerforation.new(rune, level)
		"RADIUS":
			return RuneUpgradeRadius.new(rune, level)
		"SPEED":
			return RuneUpgradeSpeed.new(rune, level)
		"STATUS_EFFECT_CHANCE":
			return RuneUpgradeStatusEffectChance.new(rune, level)
		_: push_warning("Rune upgrade " + upgrade_name + " not recognized")
	return rune


func light_attack(destination: Vector3, rune_resource_for_projectile: RuneResource) -> void:
	#print(self, " ", rune_resource_for_projectile.projectile_damage)
	var projectile = projectile_scene.instantiate()
	
	get_projectile_source().get_parent().add_child(projectile)
	projectile.source = get_projectile_source()
	projectile.global_position = get_rune_spot().global_position
	projectile.set_layers_to_hit(get_layet_to_hit())
	projectile.set_data(rune_resource_for_projectile)
	
	projectile.apply_impulse(
		(destination - get_rune_spot().global_position).normalized() * 
		rune_resource_for_projectile.projectile_speed, Vector3())

func get_projectile_source() -> Creature:
	return projectile_source

func get_layet_to_hit() -> int:
	return projectile_layer_to_hit

func set_layet_to_hit(value: int) -> void:
	projectile_layer_to_hit = value

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
	return {"rune_id": get_rune_id(), "rune_upgrades" : []}
