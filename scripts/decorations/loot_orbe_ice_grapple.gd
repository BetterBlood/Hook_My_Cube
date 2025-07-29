extends LootOrbe

class_name LootOrbeIceGrapple

var new_rune_data

func _interact() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.gain_ice_wall_grab_upgrade()
		queue_free()
	else:
		push_error("player not found !")
