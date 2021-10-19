extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	#find nearest tree
	var node_type = _blackboard.data.target_node_type
	var target_node = agent.find_closest(agent.position, Global.resource_nodes[node_type].keys())
	_blackboard.data["target_node"] = Global.resource_nodes[node_type][target_node.values()[0]]
	agent.target_position = Global.map_grid.calculate_map_position(target_node.values()[0])
	if agent.target_position:
		agent.path = agent.pathfinding.get_new_path(agent.position, agent.target_position)
		agent.set_path_line(agent.path)
		if agent.path.size() > 1:
			var desired_velocity = agent.movement.get_pursue_velocity(agent.path[1],0,0)
			agent.velocity = agent.velocity.linear_interpolate(desired_velocity, .1)
		if agent.position.distance_to(agent.target_position) < 8:
			agent.velocity = Vector2.ZERO
			return succeed()
		agent.velocity = agent.move_and_slide(agent.velocity)
	return fail()
