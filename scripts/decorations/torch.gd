extends StaticBody3D

@onready var fire: GPUParticles3D = $handle/top/Fire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("I'm a torch and the following projectile hit me, is it a fire one ? ", area.get_parent())
	if area.get_parent().has_method("get_type") && area.get_parent().get_type() == Enums.DamageType.Fire:
		fire.emitting = true
		print("Hooooo a fire one -> ignition !!!!")
	else:
		print("nop, it's not")


func _on_fire_finished() -> void:
	push_warning("nothing done then torch fire emission finished ?")


func _on_generation(size: int) -> void:
	fire.emitting = false
