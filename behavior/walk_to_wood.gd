extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	var target_item = blackboard.get_data("target_item")
	var target_pos: Vector2
	if target_item:
		target_pos = target_item.get_position()
	if target_pos:
		if agent.move_to(target_pos):
			return succeed()
	return fail()
