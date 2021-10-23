extends BTLeaf


func _tick(agent: CharacterController, _blackboard: Blackboard) -> bool:
	var item = _blackboard.data.target_item
	Global.items.erase(Global.map_grid.calculate_grid_coordinates(agent.target_position))
	item.selected = false
	agent.pickup(item)
	
	
	return succeed()
