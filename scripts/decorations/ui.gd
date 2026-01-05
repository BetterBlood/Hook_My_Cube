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


func update_lvl(lvl: int, lvl_points: int) -> void:
	$VBoxContainer/LvlInfos.text = "lvl: " + str(lvl) + " (" + str(lvl_points) + ")"


func update_essences(essences: Array[int]) -> void:
	$VBoxContainer/EssencesInfos.text = "essences: "
	for i in range(len(essences)):
		$VBoxContainer/EssencesInfos.text += str(essences[i]) + " "


func update_gold(gold: int) -> void:
	$VBoxContainer/GoldInfo.text = "gold: " + str(gold)
	
