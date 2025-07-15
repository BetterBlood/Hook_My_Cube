extends Node3D

class_name Pedestral

@onready var readable_part: MeshInstance3D = $Shelf/ReadablePart/MeshInstance3D
@onready var holder: MeshInstance3D = $Shelf/holder/MeshInstance3D
@onready var column: MeshInstance3D = $Column/StaticBody3D/MeshInstance3D
@onready var base: MeshInstance3D = $Base/StaticBody3D/MeshInstance3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var maze: Maze
var id: int = 0

var is_save_pedestral: bool
var is_loot_used: bool = false

const SAVE_COLOR = preload("res://materials/save_color.tres")
const CHEST_COLOR = preload("res://materials/chest_color.tres")

const LOOT_ORBE = preload("res://scenes/decorations/loot_orbe.tscn")

func _ready() -> void:
	var material: StandardMaterial3D
	
	if is_save_pedestral:
		material = SAVE_COLOR
	else:
		material = CHEST_COLOR
	
	readable_part.material_override = material
	holder.material_override = material
	column.material_override = material
	base.material_override = material


func set_color(color: Color) -> void:
	var material: StandardMaterial3D
	material.albedo_color = color
	
	readable_part.material_override = material
	holder.material_override = material
	column.material_override = material
	base.material_override = material
	#readable_part.material_override.normal_enabled = true
	#readable_part.material_override.normal_enabled.normal_texture = NoiseTexture2D.new()
	#readable_part.material_override.normal_enabled.normal_texture.noise = FastNoiseLite.new()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if !is_loot_used:
		animation_tree.set("parameters/Transition/transition_request", "Nearing")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if !is_loot_used:
		animation_tree.set("parameters/Transition/transition_request", "Leaving")
		use() # DEBUG : TODO: remove frome here


func use() -> void:
	if is_save_pedestral:
		maze._save_point_activated(id)
	else:
		# TODO: notify maze that chest is open !
		maze.updated_chests.append(id)
		is_loot_used = true
		
		var loot_orbe = LOOT_ORBE.instantiate()
		loot_orbe.position = position
		get_tree().root.add_child(loot_orbe)
		
		animation_tree.set("parameters/Transition/transition_request", "Destroing")
