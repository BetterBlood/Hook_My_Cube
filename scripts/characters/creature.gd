extends CharacterBody3D

class_name Creature

@export var health_component: HealthComponent

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

func can_host_status_effect() -> bool:
	return true

func get_health_component() -> HealthComponent:
	return health_component

func take_damage(	value: float, 
					att_type: Enums.DamageType, 
					armor_pen: float) -> float:
	return health_component.take_damage(value, att_type, get_type(), armor_pen)


func get_type() -> Enums.DamageType:
	return Enums.DamageType.NORMAL
