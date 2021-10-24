extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	var item = blackboard.get_data("target_item")
	agent.pickup(item)
	
	
	
	return succeed()
