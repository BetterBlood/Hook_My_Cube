extends StatusEffect 

class_name BurnEffect

func _apply_effect() -> void:
	real_target.take_fire_effect(value/(1.0/cooldown)) # or value * cd


func _clean_effect() -> void:
	pass
