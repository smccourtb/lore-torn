extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	#find nearest tree'
	#TODO : check to make sure target is not in the 'walkable" cells array and its within bounds
	var boo = Vector2(Util.randi_range(-25,25), Util.randi_range(-25,25))
	if !_blackboard.data.has("target"):
		_blackboard.data["target"] = boo + agent.position
	agent.target_position = _blackboard.data["target"]
	if agent.target_position:
		agent.path = agent.pathfinding.get_new_path(agent.position, agent.target_position)
		agent.set_path_line(agent.path)
		if agent.path.size() > 1:
			var desired_velocity = agent.movement.get_pursue_velocity(agent.path[1],0,0)
			agent.velocity = agent.velocity.linear_interpolate(desired_velocity, .1)
		if agent.position.distance_to(agent.target_position) < 5:
			agent.velocity = Vector2.ZERO
			_blackboard.data.erase("target")
			return succeed()
	agent.velocity = agent.move_and_slide(agent.velocity)
	return fail()
