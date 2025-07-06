extends StatusEffect

class_name SpeedEffect

func _apply_effect() -> void:
	#print("SpeedEffect::_apply_effect")
	real_target.take_speed_effect(effect_id, value) # or value * cd


func _clean_effect() -> void:
	#print("SpeedEffect::_clean_effect")
	real_target.remove_speed_effect(effect_id)
