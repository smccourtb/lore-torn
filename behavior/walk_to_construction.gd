extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	# pull the most recent construction and set it to target so nobody else
	# can choose the same construction
	var target: Node2D = blackboard.get_data("construction")
	var target_pos: Vector2
	# make sure target is not null
	if !target:
		return fail()
	# set the characters target position to the constructions position
	target_pos = blackboard.get_data("construction").position
	# check if valid position and move to target_position
	if agent.move_to(target_pos):
		return succeed()
	return fail()
