extends RigidBody3D
# TODO: add Projectile Class
class_name FireProjectile

const BURN_EFFECT = preload("res://scenes/fight/statusEffects/burn_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeToLive.wait_time = 5
	$TimeToLive.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_interaction_area_area_entered(area: Area3D) -> void:
	print("In Projectile detect collision with: ", area)
	#print(area.get_parent().has_method("can_host_status_effect"))
	if area.get_parent().has_method("can_host_status_effect") && \
	   area.get_parent().has_method("get_health_component"):
		var burn_effect = BURN_EFFECT.instantiate()
		#print("target should not be null: ", area.get_parent())
		burn_effect.target = area.get_parent()
		#print("target component should not be null: ", burn_effect.target.get_health_component())
		area.get_parent().add_child(burn_effect)
		queue_free()


func _on_interaction_area_body_entered(body: Node3D) -> void:
	print("Projectile: ", self , " hits ", body, ": auto destroy")
	
	queue_free()


func _on_time_to_live_timeout() -> void:
	print("Projectile living time ends: auto destroy")
	queue_free()

func get_type() -> Enums.DamageType:
	return Enums.DamageType.Fire
