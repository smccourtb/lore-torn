extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	#TODO : check to make sure target is not in the 'walkable" cells array and its within bounds
	if not agent.get_target_position():
		var current_pos = Global.chunk_pos(agent.get_global_position())
		var random_pos = agent.get_random_position_from_chunk(current_pos)
#		if (Global.map_grid.calculate_map_position(grid_pos)) in Global.get_walkable_cells():
#			print("FAILED PICK IN UNWALKABLE CELLS")
#			return fail()
#		if not Global.map_grid.is_within_bounds(grid_pos):
#			print("FAILED PICK BECAUSE OUT OF BOUNDS")
#			return fail()
		agent.set_target_position(random_pos)
		
	if agent.move_to(agent.get_target_position()):
		return succeed()
	return fail()
