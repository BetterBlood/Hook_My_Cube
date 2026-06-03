@tool
extends XRToolsViewport2DIn3D

signal new_game(player_name: String)
signal return_to_main_menu()

#@onready var player_name: LineEdit = $MainPanel/VBoxContainer/HBoxContainer/PlayerName


func _init_focus() -> void:
	pass


func _process(_delta: float) -> void:
	if InputMap.has_action("return") and Input.is_action_just_pressed("return"):
		if visible == true:
			return_to_main_menu.emit()


func _on_new_game_pressed() -> void:
	#new_game.emit(player_name.text)
	new_game.emit("teeeeeest_VR2")


func _on_return_pressed() -> void:
	return_to_main_menu.emit()


func _on_player_name_text_submitted(_new_text: String) -> void:
	_init_focus()


func _on_randomize_pressed() -> void:
	var chars = "abcdefghijklmnopqrstuvwxyz"
	var n = ""
	var chars_len = len(chars)
	for i in range(7):
		n += chars[randi()% chars_len]
	#player_name.text = n
