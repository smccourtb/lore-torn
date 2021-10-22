extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var create_item = agent.data.current_project.created_item
	var new_item = load("res://resource/items/Item.tscn").instance()
	new_item.data = create_item
	agent.get_parent().add_child(new_item)
	new_item.spawn(agent.position+ Vector2(4,4))
	new_item.position = agent.position + Vector2(4,4) # TODO: Change to find_nearest_open_neighbor or something
	for i in agent.data.current_project.materials:
		agent.data.inventory.remove_item(agent.data.inventory.get_item_index(i.keys()[0]))
	_blackboard.data.erase("target_workstation")
	_blackboard.data.erase("material_list")
	
	return succeed()
