extends BTLeaf



func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	# create or get the material list from the project reference
	# material_list is a list of strings
	# should be a list of dictionarys with type:subtype if any subtype use [] and if empty it means any
	_blackboard.data["material_list"] = agent.convert_material_list(agent.data.current_project.materials)
		
	if _blackboard.data.material_list.size() > 0:
		var item_choice = _blackboard.data.material_list.pop_back()
		_blackboard.data["item_choice"] = item_choice
	
		return succeed()
	return fail()
