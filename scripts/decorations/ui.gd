extends Control

func _ready() -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect.modulate.a = 0

func damage_tick() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1, 0.1)
	await tween.finished
	
	if self:
		var tree = get_tree()
		if tree:
			tween = tree.create_tween()
			tween.tween_property($ColorRect, "modulate:a", 0, 0.1)
