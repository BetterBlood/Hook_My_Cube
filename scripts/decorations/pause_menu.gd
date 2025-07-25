extends Control

var main: PackedScene = preload("res://scenes/main.tscn")
var previous_pause_state: bool = false
var previous_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED
@onready var continue_button: Button = $VBoxContainer/Continue

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !$".".visible:
			continue_button.grab_focus()
			previous_pause_state = get_tree().paused
			previous_mouse_mode = Input.mouse_mode
			get_tree().paused = true
			$".".show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			_on_continue_pressed()


func _on_continue_pressed() -> void:
	get_tree().paused = previous_pause_state
	$".".hide()
	Input.set_mouse_mode(previous_mouse_mode)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	# TODO: warning for user: all none saved progress will be lost
	get_tree().change_scene_to_file("res://scenes/main.tscn")
