extends BTLeaf



func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	if !(_blackboard.data.has("material_list")):
		_blackboard.data["material_list"] = agent.convert_material_list(agent.data.current_project.materials)
	print("ARRAY OF MATERIALS: ", _blackboard.data.material_list)
		
	if _blackboard.data.material_list.size() > 0:
		var item_choice = _blackboard.data.material_list.pop_back()
		_blackboard.data["item_choice"] = item_choice
	print("CHOSEIN THE ITEM: ", _blackboard.data["item_choice"])
	return succeed()
