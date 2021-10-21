extends BTLeaf

var item 
func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = _blackboard.data.target_stockpile
	var item_choice = _blackboard.data.item_choice
	var item_type: String
	var item_subtype: String
	var item
	if item_choice.size() > 1:
		item_subtype = item_choice[1]
	item_type = item_choice[0]
	
	for i in stockpile.items:
		if !item_subtype:
			if i != null and i.get_object_type() == item_type:
				item = stockpile.remove_item(stockpile.items.find(i))
		else:
			if i != null and i.get_object_type() == item_type and i.get_object_subtype() == item_subtype:
				item = stockpile.remove_item(stockpile.items.find(i))
	agent.data.inventory.add_item(item)
	agent.get_parent().remove_child(item)
	_blackboard.data.erase("item_choice")
	return succeed()
