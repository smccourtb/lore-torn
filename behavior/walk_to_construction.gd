extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	# pull the most recent construction and set it to target so nobody else
	# can choose the same construction
	var target = Global.pending_constructions.pop_back()
	# make sure target is not null
	if target:
		# save the construction object reference so we can build it when we get
		# its set position
		_blackboard.data["construction"] = target
		
		# set the characters target position to the constructions position
		agent.target_position = target.position
	# check if valid position and move to target_position
	if agent.target_position:
		agent.path = agent.pathfinding.get_new_path(agent.position, agent.target_position)
		agent.set_path_line(agent.path)
		if agent.path.size() > 1:
			var desired_velocity = agent.movement.get_pursue_velocity(agent.path[1],0,0)
			agent.velocity = agent.velocity.linear_interpolate(desired_velocity, .1)
		if agent.position.distance_to(agent.target_position) < 15:
			agent.velocity = Vector2.ZERO
			return succeed()
		agent.velocity = agent.move_and_slide(agent.velocity)
	return fail()
