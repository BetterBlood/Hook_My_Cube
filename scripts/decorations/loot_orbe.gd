extends Node3D

class_name LootOrbe

@onready var interactionDetector:= $InteractionsDetector
@export var interactionToDisplay: String = "Loot"

var loot_is_upgrade: bool = false
var new_runes: Array[int] = []
var other_upgrades: Array = [] # upgrades: [[runeType, value], [healthType, value], [grapleType, value]]

signal action_after_interation(destroy: bool)

func _ready() -> void:
	interactionDetector.interact = Callable(self, "_interact")
	if !interactionToDisplay.is_empty():
		interactionDetector.actionName += interactionToDisplay
	
	action_after_interation.connect(_action_after_interaction)
	_spawning_animation()

func _spawning_animation() -> void:
	scale = Vector3(0.001, 0.001, 0.001)
	var tween = get_tree().create_tween()
	tween.tween_property($".", "scale", Vector3(1.0, 1.0, 1.0), 1.0)

func _interact() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		if loot_is_upgrade:
			player.propose_upgrades(other_upgrades)
			queue_free()
		else:
			player.propose_new_runes(new_runes, action_after_interation)
	else:
		push_error("player not found !")

func _action_after_interaction(destroy: bool) -> void:
	if destroy:
		queue_free()


func set_loot(is_upgrade: bool, special_seed: String) -> void:
	loot_is_upgrade = is_upgrade
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = hash(special_seed)
	
	if !loot_is_upgrade:
		print("TODO: setup loot for new runes") # (not -1) cause is debug rune
		var all_runes = [0, 1, 2, 3] # TODO: get all runes id from file or load in maze or other place
		for i in range(3):
			var index = rng.randi_range(0, len(all_runes) - 1)
			new_runes.append(all_runes[index])
			all_runes.remove_at(index)
		
		#print("LootOrbe::set_loot:new_runes: ", new_runes)
	else:
		other_upgrades.append([])
		# TODO: select 3 upgrades in rune
		var upgrade_lvls: Array[int] = [0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4]
		for i in range(3):
			other_upgrades[0].append(
				[rng.randi_range(0, Rune.NBR_UPGRADES - 1),
				upgrade_lvls[rng.randi_range(0, len(upgrade_lvls) - 1)]
				])
		
		other_upgrades.append([])
		# TODO: select 3 upgrades in health
		for i in range(3):
			other_upgrades[1].append(
				[rng.randi_range(0, HealthComponent.NBR_UPGRADES - 1),
				upgrade_lvls[rng.randi_range(0, len(upgrade_lvls) - 1)]
				])
		
		other_upgrades.append([])
		# TODO: select 3 upgrades in grapple
		for i in range(2):
			other_upgrades[2].append([
				rng.randi_range(0, Grapple.NBR_UPGRADES - 1),
				upgrade_lvls[rng.randi_range(0, len(upgrade_lvls) - 1)]
				])
		
		#print("LootOrbe::set_loot:other_upgrades: ", other_upgrades)
