extends CharacterBody3D

class_name Creature

@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if health_component == null:
		push_warning("health component missing for: ", self, ", set to default")
		health_component = HealthComponent.new()
		add_child(health_component)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func can_host_status_effect() -> bool:
	return true

func get_health_component() -> HealthComponent:
	return health_component
