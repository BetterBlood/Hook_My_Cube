extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	# TODO: subscribe to interaction manager
	print("player enter orbe area")
	pass # Replace with function body.


func _on_area_3d_body_exited(body: Node3D) -> void:
	# TODO: unsubscribe to interaction manager
	print("player leave orbe area")
	pass # Replace with function body.


func _interact() -> void:
	# TODO: apply on the player the interaction effect (propose new rune, or any upgrade types)
	pass
