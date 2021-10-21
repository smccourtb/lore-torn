extends BTLeaf



func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	# create or get the material list from the project reference
	# material_list is a list of strings
	# should be a list of dictionarys with type:subtype if any subtype use [] and if empty it means any
		
	if _blackboard.data.material_list.size() > 0:
		var item_choice = _blackboard.data.material_list.pop_back()
		var item = []
		if item_choice.values()[0].empty():
			item = item_choice.keys()
			_blackboard.data["item_choice"] = item
			return succeed()
		item.append(item_choice.keys()[0])
		item.append(item_choice.values()[0])
		_blackboard.data["item_choice"] = item
		return succeed()
	return fail()
