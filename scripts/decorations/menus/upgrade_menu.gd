extends Control

@onready var upgrade_proposition: Control = $VBoxContainer/HBoxContainer/UpgradeProposition
@onready var upgrade_proposition_2: Control = $VBoxContainer/HBoxContainer/UpgradeProposition2
@onready var upgrade_proposition_3: Control = $VBoxContainer/HBoxContainer/UpgradeProposition3

var function_to_call_on_selection: Callable
var is_active_selected: bool = false # TODO: set the choice for the user (default(false) select the second rune)
var call_to_potentially_free_orbe: Signal

func _ready() -> void:
	$VBoxContainer/Close.grab_focus()

func set_up_propositions(prop_1, prop_2, prop_3, dont_forget_to_call: Callable, call_on_finish: Signal) -> void:
	function_to_call_on_selection = dont_forget_to_call
	call_to_potentially_free_orbe = call_on_finish
	if prop_1:
		upgrade_proposition.set_up_proposition(prop_1)
		upgrade_proposition.show()
	else:
		upgrade_proposition.hide()
	
	if prop_2:
		upgrade_proposition_2.set_up_proposition(prop_2)
		upgrade_proposition_2.show()
	else:
		upgrade_proposition_2.hide()
	
	if prop_3:
		upgrade_proposition_3.set_up_proposition(prop_3)
		upgrade_proposition_3.show()
	else:
		upgrade_proposition_3.hide()

func _on_upgrade_proposition_select_pressed() -> void:
	function_to_call_on_selection.call(0, is_active_selected, call_to_potentially_free_orbe)
	_on_close_pressed()


func _on_upgrade_proposition_2_select_pressed() -> void:
	function_to_call_on_selection.call(1, is_active_selected, call_to_potentially_free_orbe)
	_on_close_pressed()


func _on_upgrade_proposition_3_select_pressed() -> void:
	function_to_call_on_selection.call(2, is_active_selected, call_to_potentially_free_orbe)
	_on_close_pressed()


func _on_close_pressed() -> void:
	get_tree().paused = false
	$".".hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
