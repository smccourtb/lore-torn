extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	# store reference in a variable to shorten things
	var material_list: Array = blackboard.get_data("material_list")
	# check if empty
	if !material_list.empty():
		# pull the last item and store it
		var item_choice: Dictionary = material_list.pop_back()
		var item = []
		# check for subtype specification
		if item_choice.values()[0].empty():
			item = item_choice.keys()[0]
			blackboard.set_data("item_choice", item)
			return succeed()
		item.append(item_choice.keys()[0])
		item.append(item_choice.values()[0])
		blackboard.set_data("item_choice", item)
		return succeed()
	return fail()
