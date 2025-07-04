extends Projectile

class_name FireProjectile

func _ready() -> void:
	super._ready()
	effect = preload("res://scenes/fight/statusEffects/burn_effect.tscn")


func get_type() -> Enums.DamageType:
	return Enums.DamageType.FIRE
