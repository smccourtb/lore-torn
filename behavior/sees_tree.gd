extends BTConditional


func _pre_tick(_agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	var node_type = _blackboard.data.target_node_type
	if !Global.resource_nodes[node_type].empty():
		verified = true
