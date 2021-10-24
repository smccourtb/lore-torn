extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	var stockpile = blackboard.get_data("target_stockpile")
	var item = blackboard.get_data("target_item")
	var inventory_index = agent.data.inventory.get_item_index(item.get_object_type(), item.get_object_subtype())
	var return_item = agent.data.inventory.remove_item(inventory_index)
	stockpile.store_item(agent, return_item)
	print('Items in stockpile: ', stockpile.get_items())
	blackboard.data.erase("target_item")
	blackboard.data.erase("target_stockpile")
	return succeed()

