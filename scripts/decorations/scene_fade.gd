extends CanvasLayer

static var player_name: String = "FADE"

signal lobby_loaded()
signal maze_loaded()
signal save_id_changed(value: int)

func _ready() -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect.modulate.a = 0

func change_scene(scene: PackedScene, await_loading: Signal) -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($ColorRect, "modulate:a", 1, 0.5)
	await tween.finished
	
	get_tree().change_scene_to_packed(scene)
	if await_loading:
		await await_loading
	
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($ColorRect, "modulate:a", 0, 0.5)
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
