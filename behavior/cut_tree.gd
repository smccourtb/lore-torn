extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var node = _blackboard.data.target_node
	var node_type = _blackboard.data.target_node_type
	Global.resource_nodes[node_type].erase(Global.map_grid.calculate_grid_coordinates(node.position))
	
	node.action(agent)
	
	return succeed()
