extends CharacterBody3D

class_name Creature

@export var health_component: HealthComponent
var lvl:int = 1
var xp:float = 0.0


var layer: int = 0
var effect_ids: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if health_component == null:
		push_warning("health component missing for: ", self, ", set to default")
		health_component = HealthComponent.new()
		add_child(health_component)
	
	health_component.damage_taken.connect(_on_damage_taken)


func _on_damage_taken():
	if health_component.health <= 0:
		print(self, " is dead ! Regeneration activated !!!")
		health_component.health = health_component.max_health
		# TODO: in herited classes: do something on creature's death !


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func can_host_status_effect(id: int = 0) -> bool:
	return !effect_ids.has(id)

func get_health_component() -> HealthComponent:
	return health_component

func take_damage(	value: float, 
					att_type: Enums.DamageType, 
					armor_pen: float) -> float:
	return health_component.take_damage(value, att_type, get_type(), armor_pen)


func get_type() -> Enums.DamageType:
	return Enums.DamageType.NORMAL


func get_fire_projectile_spot() -> Marker3D:
	return null


func get_layer() -> int:
	return layer


func add_effect_id(id: int = 0) -> void:
	effect_ids[id] = true

# TODO: remove
func get_status_ids() -> Array:
	return effect_ids.keys()
