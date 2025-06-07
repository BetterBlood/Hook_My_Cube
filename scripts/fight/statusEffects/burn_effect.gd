extends Node
var cooldown: float = 0.5
var total_duration: float = 1.1
var target: Creature

func _ready() -> void:
	print("burn effect: ready")
	$Cooldown.wait_time = cooldown
	$TotalDuration.wait_time = total_duration
	
	$Cooldown.start()
	$TotalDuration.start()


func _on_total_duration_timeout() -> void:
	print("Burn effect stopped on target: ", target)
	queue_free()


func _on_cooldown_timeout() -> void:
	print("Apply burn tick on target: ", target)
	if target != null && target.get_health_component() != null:
		target.get_health_component().take_fire_effect()
		$Cooldown.start()
	else:
		print("BurnEffect not appliable on target: ", target, ", with target.get_health_component(): ", target.get_health_component())
		print("\t->\tBurn effect stopped")
		queue_free()
