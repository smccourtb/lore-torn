extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = _blackboard.data.target_stockpile.values()[0]
	var item = _blackboard.data.target_item
	print(item)
	var inventory_index = agent.data.inventory.get_item_index(item.get_object_type(), item.get_object_subtype())
	var return_item = agent.data.inventory.remove_item(inventory_index)
	stockpile.action(agent, return_item)
	_blackboard.data.erase("target_item")
	_blackboard.data.erase("target_stockpile")
	return succeed()

