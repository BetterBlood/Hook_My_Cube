extends Rune

class_name RuneUpgrade

var rune_upgraded: Rune

func _init(previous_rune: Rune) -> void:
	#print("_init de RuneUpgrade: ", self)
	rune_upgraded = previous_rune


func light_attack(destination: Vector3, rune_resource_for_projectile: RuneResource) -> void:
	#print(self, " ", get_data_to_performe_attaque().projectile_damage)
	rune_upgraded.light_attack(destination, rune_resource_for_projectile)


func heavy_attack(destination: Vector3) -> void:
	rune_upgraded.heavy_attack(destination)


func get_data_to_performe_attaque() -> RuneResource:
	#print("get_data_to_performe_attaque()::RuneUpgrade")
	return RuneResource.add(rune_upgraded.get_data_to_performe_attaque(), rune_resource)


func get_rune_id() -> int:
	return rune_upgraded.get_rune_id()

func get_save_infos() -> Dictionary:
	return rune_upgraded.get_save_infos()
