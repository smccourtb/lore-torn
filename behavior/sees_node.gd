extends BTConditional

# TODO: implement same thing as item search to make sure nothing crashes when picking a node
# add a leaf node for the purpose of picking a resource noce and marking it targeted
func _pre_tick(_agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	var node_type = _blackboard.data.target_node_type
	if !Global.resource_nodes[node_type].empty():
		verified = true
