extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	#find nearest tree
	var target_position = agent.find_nearest_object("tree", Global.resource_nodes).object.position
	print(target_position)
	if target_position:
		agent.path = agent.pathfinding.get_new_path(agent.position, target_position)
		agent.set_path_line(agent.path)
#		if path.size() > 1:
		var desired_velocity = agent.movement.get_pursue_velocity(target_position,0,0)
		agent.velocity = agent.velocity.linear_interpolate(desired_velocity, 0.1)
		
		if agent.position.distance_to(target_position) < 15:
			agent.velocity = Vector2.ZERO
			return succeed()
	agent.velocity = agent.move_and_slide(agent.velocity)
	return fail()
