extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = agent.find_applicable_stockpiles("wood")
	if !stockpile:
		return fail()
	_blackboard.data["stock"] = stockpile
	var rect = stockpile.values()[0].rect.position
	agent.target_position = rect
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
