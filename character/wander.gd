extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	#TODO : check to make sure target is not in the 'walkable" cells array and its within bounds
	var boo = Vector2(Util.randi_range(-25,25), Util.randi_range(-25,25))
	if Global.map_grid.is_within_bounds(Global.map_grid.calculate_grid_coordinates(boo + agent.position)):
		if not blackboard.data.has("target"):
			blackboard.set_data("target", boo + agent.position)
		if agent.move_to(blackboard.get_data("target")):
			blackboard.data.erase("target")
			return succeed()
	return fail()
