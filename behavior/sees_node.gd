extends BTConditional

func _pre_tick(_agent: CharacterController, blackboard: Blackboard) -> void:
	verified = false
	var node_type: String = blackboard.get_data("target_node_type")
	var nodes: Dictionary = Global.get_resource_nodes(node_type)
	if !nodes.empty():
		verified = true
