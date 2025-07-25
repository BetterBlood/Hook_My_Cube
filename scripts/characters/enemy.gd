extends Creature

class_name Enemy

static var next_id = 0
var id: int
signal is_dead(id: int)

@export var is_in_lobby: bool = false

var damage_type: Enums.DamageType = Enums.DamageType.NORMAL

const XP_ORBE = preload("res://scenes/decorations/xp.tscn")
const GOLD_ORBE = preload("res://scenes/decorations/gold.tscn")
const ESSENCE_ORBE = preload("res://scenes/decorations/essence.tscn")


func _ready() -> void:
	super._ready()
	layer = 4


func _on_damage_taken():
	if is_in_lobby:
		super._on_damage_taken() # TODO: probably remove this later
	else:
		if health_component.health <= 0:
			_death_sequence()

## depth_ratio: [0.0; 1.0]
## difficulty: [-2; 2]
func set_mob_data(human_seed: String, difficulty: int, depth_ratio: float) -> void:
	#print("TODO: set_mob_data override in subclasses !")
	print("Enemy::set_mob_data::human_seed: ", human_seed, ", difficulty: ", difficulty, ", depth_ratio: ", depth_ratio)
	
	# [-0.125; 0.125]
	var new_diff = difficulty / (4.0 * 4.0) # ~normalisation (/4) attenuation (/4)
	
	if depth_ratio + new_diff >= 1/3.0: # typed mobs appears nearer to begin with high difficulty
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.seed = hash(human_seed)
		damage_type = Enums.DamageType.values()[rng.randi_range(0, len(Enums.damage_type_grid) - 1)] 
	
	var lvl_max = (difficulty + 3) * 10 # [10; 50]
	lvl = max(1, int(lvl_max * depth_ratio)) # at least lvl 1, max [10, 20, 30, 40, 50]
	xp = lvl * (5 - difficulty) # lvl * [7; 3] => [7; 3] to [350; 150]


func _death_sequence() -> void:
	# TODO: animations
	
	var xp_orbe = XP_ORBE.instantiate()
	xp_orbe.set_amount(xp)
	xp_orbe.position = global_position
	get_parent().get_parent().add_child(xp_orbe)
	
	var gold_orbe = GOLD_ORBE.instantiate()
	gold_orbe.set_amount(lvl)
	gold_orbe.position = global_position + Vector3(0.2, 0, 0.2)
	get_parent().get_parent().add_child(gold_orbe)
	
	var essence_orbe = ESSENCE_ORBE.instantiate()
	essence_orbe.set_amount(1)
	essence_orbe.position = global_position + Vector3(-0.2, 0, -0.3)
	get_parent().get_parent().add_child(essence_orbe)
	essence_orbe.set_type(get_type())
	
	
	is_dead.emit(id) # notify the death (for the spawner or else)
	
	queue_free()


static func get_next_id() -> int:
	next_id += 1
	return next_id - 1


func get_type() -> Enums.DamageType:
	return damage_type
