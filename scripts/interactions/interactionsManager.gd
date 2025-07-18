extends Node3D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var label: Label# = player.get_interaction_label()#$Label

const beginText: String = "" #"[F] "

var activeAreas: Array[InteractionsDetector] = []
var canInteract: bool = true
var previous_size: int = 0

func registerArea(area: InteractionsDetector):
	activeAreas.push_back(area)

func unregisterArea(area: InteractionsDetector):
	var index = activeAreas.find(area)
	if index != -1:
		activeAreas.remove_at(index)

func _process(_delta: float) -> void:
	if activeAreas.size() != previous_size:
		previous_size = activeAreas.size()
		if canInteract:
			if activeAreas.size() == 0 :
				label.hide()
			else :
				if activeAreas.size() > 1 :
					activeAreas.sort_custom(_sortByDistToPlayer)
				var currArea: InteractionsDetector = activeAreas[0]
				_setActiveLabel(currArea)
				label.show()
		else:
			label.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") && canInteract:
		if activeAreas.size() > 0:
			canInteract = false
			label.hide()
			
			await activeAreas[0].interact.call()
			
			canInteract = true

func _setActiveLabel(currArea: InteractionsDetector):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		label = player.get_interaction_label()
	label.text = beginText + currArea.actionName

func _sortByDistToPlayer(a1: InteractionsDetector, a2: InteractionsDetector):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")
		label = player.get_interaction_label()
	return player.global_position.distance_to(a1.global_position) < player.global_position.distance_to(a2.global_position)
