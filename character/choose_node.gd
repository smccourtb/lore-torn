extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var node_type: String = blackboard.get_data("target_node_type")
	# find the nearest node and we only want the position, not the distance
	var target_node: Vector2 = agent.find_closest(agent.position, 
													 Global.resource_nodes[node_type].keys()
													).values()[0]
	if Global.resource_nodes[node_type][target_node].targeted:
		return fail()
	Global.resource_nodes[node_type][target_node].targeted = true
	blackboard.set_data("target_node", target_node)
	return succeed()
