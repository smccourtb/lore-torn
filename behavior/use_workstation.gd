extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var create_item = agent.data.current_project.created_item
	print("CREATED ITEM RESOURCE: ", create_item)
	var new_item = load("res://resource/items/Item.tscn").instance()
	new_item.data = create_item
	agent.get_parent().add_child(new_item)
	new_item.spawn(agent.position+ Vector2(4,4))
	new_item.position = agent.position + Vector2(4,4) # TODO: Change to find_nearest_open_neighbor or something
	
	return succeed()
