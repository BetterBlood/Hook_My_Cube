@icon("res://images/icons/heart_3d.svg")
extends Node3D

class_name HealthComponent

@export var max_health: float = 10.0
var health: float = max_health
@export var health_regen_per_sec: float = 0.0
#var health_regen_timer: float = 0.25
var health_regen_timer_reset: float = 0.25
@export var armor: float = 0.0
@export var penetration_resistance: float = 0.0 # [0; 1] 

@export var max_speed: float = 5
var speed: float = max_speed

signal damage_taken()
var health_regen_timer: Timer = Timer.new()

func _ready() -> void:
	health_regen_timer.wait_time = health_regen_timer_reset
	health_regen_timer.autostart = true
	health_regen_timer.timeout.connect(_passive_heal)
	add_child(health_regen_timer)


#func _process(delta: float) -> void:
	#if health_regen_per_sec > 0.0:
		#health_regen_timer -= delta
		#if health_regen_timer <= 0:
			#health_regen_timer = health_regen_timer_reset
			#health = min(health + health_regen_per_sec / (1.0 / health_regen_timer_reset), max_health)


func _passive_heal() -> void:
	if health_regen_per_sec > 0.0 && health < max_health:
		health = min(health + health_regen_per_sec / (1.0 / health_regen_timer_reset), max_health)
		#print("health: ", health)
	health_regen_timer.start(health_regen_timer_reset)

func take_fire_effect(value: float) -> float:
	print(get_parent(), ": I'm literally on fire.... taking ", value, " damages.")
	var damage: float = value * _get_grid_modifier(Enums.DamageType.FIRE, get_parent().get_type())
	
	health = max(health - damage, 0.0)
	damage_taken.emit()
	
	return damage

func get_icons_path() -> String:
	return "icon.svg"

func take_damage(	value: float, 
					att_type: Enums.DamageType, 
					def_type: Enums.DamageType, 
					armor_pen: float
				) -> float:
	var damage: float = value * _get_grid_modifier(att_type, def_type)
	damage -= max(armor - max((1.0 - penetration_resistance), 0.0) * armor_pen, 0.0)
	#print("HealthComponent::take_damage() ", value, " ", att_type, " ", def_type, " ", armor_pen, " ", damage)
	
	if damage <= 0:
		damage = 0.01 # <( not impossible to make damage, but really hard ) 
	
	#print("HealthComponent:: health: ", health, ", armor: ", armor)
	health = max(health - damage, 0.0)
	damage_taken.emit()
	#print("HealthComponent:: health: ", health)
	return damage

func _get_grid_modifier(
						att_type: Enums.DamageType,
						def_type: Enums.DamageType
						) -> float:
	return Enums.get_grid_modifier(att_type, def_type) # TODO get grid damage modifier corresponding to types given
