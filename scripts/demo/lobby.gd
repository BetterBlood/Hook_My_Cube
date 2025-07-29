extends Node3D

class_name Lobby

signal launch_game(player_name: String)

@export var size: int = 7 # DEBUG

var unlocked_runes: Array[int] = [0, 1, 2, 3] #TODO: default [0]
var gold: int = 0
var essences: Array[int] = [0, 0, 0, 0]

const Logger = preload("res://scripts/CSharp/Logger.cs")
var logger:Logger = Logger.new()

var debug_size: int = 3 # DEBUG
var polyrinthe: Polyrinthe = Polyrinthe.new()
@onready var player: Player = $Player

var maze_scene: PackedScene = preload("res://scenes/maze.tscn")


func _ready() -> void:
	player.current_player_name = SceneFade.player_name
	add_child(logger)
	logger.Info("An informational message: " + self.to_string());
	logger.Debug("A Debug message: " + self.to_string());
	
	for line in logger.GetLines():
		print(line)
	print()
	
	add_child(polyrinthe)
	polyrinthe.position = Vector3(48.841, 5.24, 0)
	polyrinthe.rotation = Vector3(0, -PI/2, 0)
	polyrinthe.clean()
	polyrinthe.algo = polyrinthe.GENERATION_ALGORITHME.DFS_LBL_ALT_6
	polyrinthe.generate(debug_size, "DEBUG", [-1, -1, 1])
	Maze.set_tag_for_collision_layer(polyrinthe)
	polyrinthe.display()
	Maze.apply_collision_layer(polyrinthe)
	
	if !Enums.damage_type_loaded:
		var config = ConfigFile.new()
		var err = config.load("user://damageGrid.cfg")
		if err != OK:
			Enums.save_grid_damage_type()
		else:
			Enums.load_grid_damage_type(config, true)
	
	if not FileAccess.file_exists("user://" + player.get_player_name() + "/meta.save"):
		save_meta() # initialise the save on first time with this username
	
	#call_deferred("load_meta")
	load_meta()
	SceneFade.emit_signal("lobby_loaded")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch_generation"):
		print("pressed")
		
		# DEBUG
		player.health_component.add_perm_upgrade(0, 2)
		save_meta()
		print("player.health_component.get_max_life(): ", player.health_component.get_max_health())
		# DEBUG
		
		launch_game.emit(player.get_player_name())
		
		#initialise the file containing maze info
		_initialize_new_maze_file_save()
		# player initialisation needed to keep the lobby rune
		player.save_progression(0) #TODO: get real begin_id from polyrinthe
		SceneFade.change_scene(maze_scene, SceneFade.maze_loaded)
		#get_tree().change_scene_to_packed(maze_scene)


func _initialize_new_maze_file_save() -> void:
	var save_file = FileAccess.open("user://" + player.get_player_name() + "/maze.save", FileAccess.WRITE)
	if save_file == null:
		push_error("Cannot save maze data. FileAccess error: " + str(save_file.get_error()))
		return
	
	#TODO: get real data from the room of maze selection in lobby
	var save_dict = {
		"seed" : "DEBUG" if player.get_player_name() == "DEBUG" else "", # TODO get the seed choosen by the player !
		"size" : 7,
		"begin_id" : 0,
		"generation_used" : Polyrinthe.GENERATION_ALGORITHME.DFS_LBL_ALT_6,
		"difficulty" : 0, # [-2; 2]
		"default_tags": [ # TODO: other tags needed !! # [int]
			1, # wall default collision layers 
			0, # color for room near chests
		],
		"updated_tags": [# [[int]]
			[]
		],
		"updated_chests": [], # [int]
		"updated_spawners": {} # {int, [int]}
	}
	
	var json_string = JSON.stringify(save_dict)
	
	save_file.store_line(json_string)

# use this to save meta data about player (on health_component upgrade bought and rune unlocked)
func save_meta() -> void:
	var save_file = FileAccess.open("user://" + player.get_player_name() + "/meta.save", FileAccess.WRITE)
	if save_file == null:
		print("Meta Data: first save for user: " + player.get_player_name())
		
		# directory creation with user name
		DirAccess.make_dir_absolute("user://" + player.get_player_name())
		save_file = FileAccess.open("user://" + player.get_player_name() + "/meta.save", FileAccess.WRITE)
		if save_file == null:
			push_error("Cannot save meta data. FileAccess error: " + str(save_file.get_error()))
			return
	
	var save_dict = {
		"current_player_name" : player.get_player_name(),
		"unlocked_runes" : unlocked_runes,
		"equiped_rune_lobby" : player.active_rune.get_rune_id(),
		"gold" : gold,
		"essences" : essences,
		"health_component_upgrades" : player.health_component.get_perm_data(),
	}
	
	var json_string = JSON.stringify(save_dict)
	
	save_file.store_line(json_string)


func load_meta() -> void:
	if not FileAccess.file_exists("user://" + player.get_player_name() + "/meta.save"):
		push_error("player: " + player.get_player_name() + " does not exist. Player meta load failed")
		return
		
	var save_file = FileAccess.open(
		"user://" + player.get_player_name() + "/meta.save", 
		FileAccess.READ)
	
	var meta_data = null
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			push_warning("JSON Parse Error: " + json.get_error_message() + " in " + json_string + " at line " + json.get_error_line())
			continue
		
		meta_data = json.data
	
	gold = meta_data["gold"]
	essences.clear()
	for essence in meta_data["essences"]:
		essences.append(int(essence))
	unlocked_runes.clear()
	for rune_id in meta_data["unlocked_runes"]:
		unlocked_runes.append(int(rune_id))
	#TODO: call here the methode to display selection and other stuff about runes in lobby
	
	#player.call_deferred("initialize_player").bind(meta_data, null, null)
	player.initialize_player(meta_data, null, null)
