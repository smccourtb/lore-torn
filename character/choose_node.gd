extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	var node_type: String = blackboard.get_data("target_node_type")
	# get a copy of the chosen node types positions
	var nodes_copy: Array = Global.get_resource_nodes(node_type).keys().duplicate()
	while !nodes_copy.empty():
	# find the nearest node and we only want the position, not the distance hence values[0]
		var target_node: Vector2 = agent.find_closest(agent.position, nodes_copy).values()[0]
		# if node hasn't already been selected by another character
		if not Global.get_resource_nodes(node_type).get(target_node).targeted:
			Global.resource_nodes[node_type][target_node].targeted = true
			blackboard.set_data("target_node", target_node)
			return succeed()
		if nodes_copy.erase(target_node):
			continue
	return fail()
