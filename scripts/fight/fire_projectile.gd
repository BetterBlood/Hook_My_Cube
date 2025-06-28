extends RigidBody3D
# TODO: add Projectile Class
class_name FireProjectile

const BURN_EFFECT = preload("res://scenes/fight/statusEffects/burn_effect.tscn")
@onready var interaction_area: Area3D = $InteractionArea

var perforation_count: int = 1 # default 0 # number of ennemies that can be perfored by projectile
var speed:float = 7.0
var bouncing_count: int = 1 # default 0 # number of walls that projectile can bounced on
var status_effect_chance: float = 1.0 # [0;1] # default 0
var armor_penetration: float = 1.0
var damage: float = 5.0

var source: Creature


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimeToLive.wait_time = 5
	$TimeToLive.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_layers_to_hit(layers: int) -> int:
	interaction_area.collision_mask = layers
	return interaction_area.collision_mask


func _on_interaction_area_area_entered(area: Area3D) -> void:
	print("In Projectile detect collision with: ", area)
	#print(area.get_parent().has_method("can_host_status_effect"))
	if area.get_parent().has_method("get_health_component"):
		var target = area.get_parent()
		if target.has_method("take_damage"):
			#print("On: ", target, " damage dealed: ", damage)
			var damage_taken = target.take_damage(damage, get_type(), armor_penetration)
			#print("On: ", target, " damage taken: ", damage_taken)
		
		if 	target.has_method("can_host_status_effect") && \
			status_effect_chance > randf_range(0,1):
			var burn_effect = BURN_EFFECT.instantiate()
			burn_effect.target = target
			target.add_child(burn_effect)
		
		#print("Projectile: ", self, ": perforation_count: ", perforation_count)
		if perforation_count <= 0:
			#print("Projectile: ", self , ": perforating destroy reached")
			queue_free()
		perforation_count -= 1


func _on_interaction_area_body_entered(_body: Node3D) -> void:
	#print("Projectile: ", self , " hits ", body, ", bouncing_count: ", bouncing_count)
	
	if bouncing_count <= 0:
		#print("Projectile: ", self , ": bouncing destroy reached")
		queue_free()
	
	bouncing_count -= 1


func _on_time_to_live_timeout() -> void:
	print("Projectile living time reached: auto destroy")
	queue_free()


func get_type() -> Enums.DamageType:
	return Enums.DamageType.FIRE
