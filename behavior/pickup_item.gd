extends BTLeaf

var item 
func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = _blackboard.data.target_stockpile
	for i in stockpile.items:
		if i!= null and  i.get_object_type() == _blackboard.data.item_choice:
			item = stockpile.remove_item(stockpile.items.find(i))
			print("THIS IS THE ITEM: ", item)
	agent.data.inventory.add_item(item)
	_blackboard.data.erase("item_choice")
	return succeed()
