extends Node3D

var xr_interface: XRInterface

func _ready() -> void:
	# VR-XR stuff:
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR succesfully initialized")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
