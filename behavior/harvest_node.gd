extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var target_node: Vector2 = blackboard.get_data("target_node")
	var node_type: String = blackboard.get_data("target_node_type")
	# Erase from resource node dictionary
	Global.resource_nodes[node_type].erase(target_node)
	# Erase from map data
	var node = Global.map_data[Global.chunk_grid.calculate_grid_coordinates(Global.map_grid.calculate_map_position(target_node))].nodes[node_type]
	node[Global.map_grid.calculate_map_position(target_node)].action(agent)
	print(node.erase(Global.map_grid.calculate_map_position(target_node)))
	blackboard.data.erase("target_node_type")
	blackboard.data.erase("target_node")
	return succeed()
