@tool
extends XRToolsViewport2DIn3D

signal new_game()
signal continue_game()


func _on_new_game_pressed() -> void:
	print("new game pressed ?")
	new_game.emit()


func _on_continue_pressed() -> void:
	print("continue pressed ?")
	continue_game.emit()


func _init_focus() -> void:
	pass # TODO check if can be removed for VR


func _on_options_pressed() -> void:
	# TODO: add options (volume, fullscreen), reglage, controls etc...
	print("option pressed from main menu")


func _on_exit_pressed() -> void:
	print("exit pressed ?")
	get_tree().quit(0)
