extends Node

var lobby_scene: PackedScene = preload("res://scenes/demo/lobby.tscn")
var maze_scene: PackedScene = preload("res://scenes/maze.tscn")


func _ready() -> void:
	$MainMenu.new_game.connect(_new_game_menu)
	$MainMenu.continue_game.connect(_continue_game_menu)
	
	$NewGameMenu.new_game.connect(_start_new_game)
	$NewGameMenu.return_to_main_menu.connect(_return_to_main_menu)
	$ContinueMenu.continue_game.connect(_continue_game)
	$ContinueMenu.return_to_main_menu.connect(_return_to_main_menu)
	
	_return_to_main_menu()


func _new_game_menu() -> void:
	$MainMenu.hide()
	$NewGameMenu.show()
	$NewGameMenu._init_focus()


func _continue_game_menu() -> void:
	$MainMenu.hide()
	$ContinueMenu.show()
	$ContinueMenu._init_focus()


func _return_to_main_menu() -> void:
	$ContinueMenu.hide()
	$NewGameMenu.hide()
	$MainMenu.show()
	$MainMenu._init_focus()


func _start_new_game(player_name: String = "default") -> void:
	#TODO: check if name is okey for file system
	
	# check that not already used
	if _player_exist(player_name):
		push_warning("Player name: '" + player_name + "' already exist !")
		# TODO: GRAPHICS: instead of nothing call a function on new_menu that player name is already taken
		return
	
	SceneFade.player_name = player_name
	_add_new_player(SceneFade.player_name)
	SceneFade.change_scene(lobby_scene, SceneFade.lobby_loaded)


func _continue_game(player_name: String = "default") -> void:
	# check if name is already a known name
	if player_name.is_empty() or !_player_exist(player_name):
		push_warning("Player name: '" + player_name + "' does not exist !")
		# TODO: GRAPHICS: instead of nothing call a function on continue_menu that player name is unknown
		return
	
	SceneFade.player_name = player_name
	
	if not FileAccess.file_exists("user://" + player_name + "/progression.save"):
		SceneFade.change_scene(lobby_scene, SceneFade.lobby_loaded)
	else:
		SceneFade.change_scene(maze_scene, SceneFade.maze_loaded)


static func _player_exist(player_name: String) -> bool:
	var players_config = ConfigFile.new()
	var err = players_config.load("user://players.cfg")
	
	if err != OK:
		return false
	
	for player: String in players_config.get_sections():
		if player == player_name:
			return true
	
	return false


func get_players_config() -> Variant:
	var players_config = ConfigFile.new()
	var err = players_config.load("user://players.cfg")
	
	if err != OK:
		return null
	else:
		return players_config


func _add_new_player(player_name: String = "default") -> void:
	var players_config = get_players_config()
	
	if !players_config:
		players_config = ConfigFile.new()
		
	players_config.set_value(player_name, "player_name", player_name)
	players_config.set_value(player_name, "volume", 50)
	players_config.set_value(player_name, "music", 50)
	players_config.set_value(player_name, "sfx", 50)
	
	players_config.save("user://players.cfg")
