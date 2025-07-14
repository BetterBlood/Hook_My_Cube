extends Node3D

class_name Pedestral

@onready var readable_part: MeshInstance3D = $Shelf/ReadablePart/MeshInstance3D
@onready var holder: MeshInstance3D = $Shelf/holder/MeshInstance3D
@onready var column: MeshInstance3D = $Column/StaticBody3D/MeshInstance3D
@onready var base: MeshInstance3D = $Base/StaticBody3D/MeshInstance3D

var is_save_pedestral: bool = false

func set_color(color: Color) -> void:
	readable_part.mesh.material.albedo_color = color
	holder.mesh.material.albedo_color = color
	column.mesh.material.albedo_color = color
	base.mesh.material.albedo_color = color
