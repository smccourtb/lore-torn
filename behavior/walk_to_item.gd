extends BTLeaf

var item_choice
var target_stockpile

func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	var item_choice: Array = blackboard.get_data("item_choice")
	if item_choice.size() < 2 or item_choice.back().empty():
		target_stockpile = agent.check_for_stored_item(item_choice.front())
	else:
		target_stockpile = agent.check_for_stored_item(item_choice.front(), item_choice.back()[0])
	print("TARGET STOCKPILE: ", target_stockpile)
	blackboard.set_data("target_stockpile", target_stockpile)
#	var rect: Vector2 = Global.map_grid.calculate_map_position(target_stockpile.values()[0].rect.position)
	agent.target_position = Global.map_grid.calculate_map_position(target_stockpile.get_start_coord())
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
