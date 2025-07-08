extends Node3D

class_name Maze

@export var size: int = 10 # DEBUG
@export var polyrinthe: Polyrinthe = Polyrinthe.new()

const Logger = preload("res://scripts/CSharp/Logger.cs")
const ICE = preload("res://materials/ice.tres")
var logger:Logger = Logger.new()
const ENV_VALUE = 1
const NORMAL_GRAPPLE = 16
const ICE_GRAPPLE = 32
const NORMAL_WALL_VALUE = NORMAL_GRAPPLE + ENV_VALUE
const ICE_WALL_VALUE = ICE_GRAPPLE + ENV_VALUE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(logger)
	logger.Info("An informational message: " + self.to_string());
	logger.Debug("A Debug message: " + self.to_string());
	
	for line in logger.GetLines():
		print(line)
	print()
	
	var config = ConfigFile.new()
	var err = config.load("user://damageGrid.cfg")
	
	if err != OK:
		_save_grid_damage_type()
	else:
		_load_grid_damage_type(config, true)
	
	add_child(polyrinthe)
	
	_initialise_world()


func _save_grid_damage_type() -> void:
	var config = ConfigFile.new()
	config.set_value("NORMAL", "grid", [1, 0.5, 0.5, 0.5])
	config.set_value("FIRE", "grid", [1.5, 1, 2, 0.5])
	config.set_value("PLANT", "grid", [1.5, 0.5, 1, 2])
	config.set_value("ELEC", "grid", [1.5, 2, 0.5, 1])
	config.save("user://damageGrid.cfg")
	
	for damage_type in config.get_sections():
		print(damage_type)
		if (	!Enums.damage_type_grid.has(damage_type)) && \
				len(config.get_value(damage_type, "grid")) == len(config.get_sections()):
			Enums.damage_type_grid[damage_type] = config.get_value(damage_type, "grid")


func _load_grid_damage_type(config: ConfigFile, erase: bool = false) -> void:
	for damage_type in config.get_sections():
		if (	!Enums.damage_type_grid.has(damage_type)) && \
				len(config.get_value(damage_type, "grid")) == len(config.get_sections()):
			Enums.damage_type_grid[damage_type] = config.get_value(damage_type, "grid")
		else:
			push_error("Error while reading 'damageGrid.cfg'. damage_type_grid may not correctly be initialised. Please verify file content !")
			config.clear()
			if erase:
				_save_grid_damage_type()
			else:
				print("#TODO : close the application without erasing the file")
			break


func _initialise_world() -> void:
	polyrinthe.clean()
	polyrinthe.algo = polyrinthe.GENERATION_ALGORITHME.DFS_LBL_ALT_6
	polyrinthe.room_scale = 2
	polyrinthe.generate(size, "DEBUG", [-1, -1, 1])
	
	set_tag_for_collision_layer(polyrinthe)
	
	polyrinthe.display()
	
	apply_collision_layer(polyrinthe, ICE)
	
	_initialise_player()


func _initialise_player():
	pass # TODO


static func _generate_array(array_size: int, normal_value: int, ice_value: int) -> Array[int]:
	var array: Array[int] = []
	
	for i in range(array_size * 2/3.):
		array.append(normal_value)
		
	for i in range(array_size * 2/3., array_size):
		array.append(ice_value)
		
	return array


static func set_tag_for_collision_layer(maze: Polyrinthe) -> void:
	var max_depth = maze.cubeGraph.get_deepest()
	maze.tag_spreads_wide_way(0, 2, max_depth, _generate_array(max_depth + 1, NORMAL_WALL_VALUE, ICE_WALL_VALUE))


static func apply_collision_layer(maze: Polyrinthe, material: StandardMaterial3D = ICE) -> void:
	for key in maze.maze.keys():
		var cube: CubeCustom = maze.maze.get(key)
		var col_layer = maze.cubeGraph.get_tag(key, 2)
		for wall: Node3D in cube.get_children():
			wall.collision_layer = col_layer
			if col_layer == ICE_WALL_VALUE:
				#var newMaterial = StandardMaterial3D.new()
				#newMaterial.albedo_color = Color(0.3, 1, 1, 1)
				wall.get_children()[0].material_override = material
