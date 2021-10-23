extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	var target_node: Vector2 = blackboard.get_data("target_node")
	var node_pos: Vector2 = Global.map_grid.calculate_map_position(target_node)
	if agent.move_to(node_pos):
		return succeed()
	return fail()
