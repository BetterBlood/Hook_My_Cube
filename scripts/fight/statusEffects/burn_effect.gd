extends Node
var cooldown: float = 0.5
var total_duration: float = 1.1
var target: Creature

var real_target: HealthComponent

# TODO
var real_source: HealthComponent
var value: float = 1 # burn:damage, slow:slow_penalty, shock:shock_duration

func _ready() -> void:
	print("burn effect: ready")
	$Cooldown.wait_time = cooldown
	$TotalDuration.wait_time = total_duration
	
	$Cooldown.start()
	$TotalDuration.start()
	
	if target != null && target.get_health_component() != null:
		real_target = target.get_health_component()


func _on_total_duration_timeout() -> void:
	print("Burn effect stopped on target: ", target)
	queue_free()


func _on_cooldown_timeout() -> void:
	print("Trying to apply burn tick on target: ", target)
	if target != null && real_target != null:
		real_target.take_fire_effect(value)
		$Cooldown.start()
	else:
		print("BurnEffect not appliable on target: ", target, ", with target.get_health_component(): ", real_target)
		print("\t->\tBurn effect stopped")
		queue_free()
