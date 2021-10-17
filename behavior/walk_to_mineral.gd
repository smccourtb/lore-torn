extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	if Global.items.has("mineral") and Global.items["mineral"].size() > 0:
		var target = agent.find_nearest_object("mineral", Global.items["mineral"])
	
		agent.target_position = target.object.position
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
