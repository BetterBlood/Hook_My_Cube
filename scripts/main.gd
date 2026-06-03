extends Node

var lobby_scene: PackedScene = preload("res://scenes/demo/lobby.tscn")
var maze_scene: PackedScene = preload("res://scenes/maze.tscn")

var main_menu
var new_game_menu
var continue_menu

var main_menu_vr
var new_game_menu_vr
var continue_menu_vr

signal new_game_menu_from_vr

# VR-XR stuff:
var xr_interface: XRInterface

func _ready() -> void:
	# VR-XR stuff:
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR succesfully initialized")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
		
		main_menu_vr = $Viewport2Din3D_Main
		new_game_menu_vr = $Viewport2Din3D_NewGame
		continue_menu_vr = $Viewport2Din3D_Continue
		
	else:
		print("OpenXR failed initialization, headset probably not connected.")
		if $XROrigin3D:
			$XROrigin3D.queue_free()
	
	main_menu = $MainMenu
	new_game_menu = $NewGameMenu
	continue_menu = $ContinueMenu
	
	main_menu.new_game.connect(_new_game_menu)
	main_menu.continue_game.connect(_continue_game_menu)
	
	new_game_menu.new_game.connect(_start_new_game)
	new_game_menu.return_to_main_menu.connect(_return_to_main_menu)
	continue_menu.continue_game.connect(_continue_game_menu)
	continue_menu.return_to_main_menu.connect(_return_to_main_menu)
	continue_menu.erase_player.connect(_remove_player)
	
	_return_to_main_menu()
	
	SceneFade.main_loaded.emit()

func test():
	print("test")
	new_game_menu_from_vr.emit()

func _new_game_menu() -> void:
	print("func ?")
	if main_menu_vr:
		main_menu_vr.hide()
		new_game_menu_vr.show()
		new_game_menu_vr._init_focus()
		print("VR ?")
	main_menu.hide()
	new_game_menu.show()
	new_game_menu._init_focus()


func _continue_game_menu() -> void:
	main_menu.hide()
	continue_menu.show()
	continue_menu._init_focus()


func _return_to_main_menu() -> void:
	continue_menu.hide()
	new_game_menu.hide()
	main_menu.show()
	main_menu._init_focus()


func _start_new_game(player_name: String = "default") -> void:
	#TODO: check if name is okey for file system
	
	# check that not already used
	if player_name.is_empty() or _player_exist(player_name):
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
	
	for player_name_tmp: String in players_config.get_sections():
		if player_name_tmp == player_name:
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

func _remove_player(player_name: String) -> void:
	var players_configs = get_players_config()
	
	if !players_configs:
		push_warning("no config file found, so nothing is deleted")
		return
	
	players_configs.erase_section(player_name)
	players_configs.save("user://players.cfg")
	SceneFade._remove_player(player_name)

	
	_continue_game_menu()
