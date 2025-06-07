@icon("res://images/icons/heart_3d.svg")
extends Node3D

class_name HealthComponent

func take_fire_effect() -> void:
	print(get_parent(), ": I'm literally on fire....")

func get_icons_path():
	return "icon.svg"
