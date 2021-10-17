extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var create_item = agent.data.current_project.created_item
	var new_item = load("res://Item.tscn").instance()
	new_item.data = create_item
	new_item.spawn(agent.position+ Vector2(4,4))
	new_item.position = agent.position+ Vector2(4,4)
	get_tree().get_root().add_child(new_item)
	return succeed()
