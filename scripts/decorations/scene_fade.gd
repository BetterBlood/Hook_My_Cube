extends CanvasLayer

static var player_name: String = "FADE"

signal lobby_loaded()
signal maze_loaded()
signal save_id_changed(value: int)
signal boss_room_loaded()
signal costs_changed()
signal main_loaded()

func _ready() -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect.modulate.a = 0

func change_scene(scene: PackedScene, await_loading: Signal) -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	await fade()
	
	get_tree().change_scene_to_packed(scene)
	if await_loading:
		await await_loading
	
	await fade(false)
	
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	get_tree().paused = false # prevent pause on changing scene, fake freeze

func change_scene_with_file(scene: String, await_loading: Signal) -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	await fade()
	
	get_tree().change_scene_to_file(scene)
	if await_loading:
		await await_loading
	
	await fade(false)
	
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	get_tree().paused = false # prevent pause on changing scene, fake freeze

func fade(in_out: bool = true) -> Signal:
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($ColorRect, "modulate:a", 1 if in_out else 0, 0.5)
	return tween.finished

func _erase_player_progress(player_name_to_erase_progression: String) -> void:
	DirAccess.remove_absolute("user://" + player_name_to_erase_progression + "/progression.save")
	DirAccess.remove_absolute("user://" + player_name_to_erase_progression + "/maze.save")

func _remove_player(player_name_to_remove: String) -> void:
	_erase_player_progress(player_name_to_remove)
	DirAccess.remove_absolute("user://" + player_name_to_remove + "/meta.save")
	DirAccess.remove_absolute("user://" + player_name_to_remove)
	
