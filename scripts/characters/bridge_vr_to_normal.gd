extends XRController3D

class_name XRBridgeController3D

func _process(_delta):
	_bridge_action("attack", "attack")
	_bridge_action("jump", "jump")
	_bridge_action("grapple", "grapple")
	_bridge_action("interact", "Interact")

func _bridge_action(xr_action_name: String, input_map_name: String):
	if is_button_pressed(xr_action_name):
		Input.action_press(input_map_name)
	else:
		Input.action_release(input_map_name)
