extends BTConditional


var have_materials: int = 0

func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	
	# dictionary of needed materials with type being the keys and amount being the value
	var materials_needed = agent.data.current_project.materials
	var character_inventory = agent.data.inventory.items.duplicate()
	# i = the type of object ( string )
	for i in materials_needed:
		for j in character_inventory:
			if j:
				if j.get_object_type() == i.keys()[0]:
					have_materials += 1
			else:
				continue
		
	if have_materials >= materials_needed.size():
		print("I HAVE THE MATERIALS")
		have_materials = 0
		verified = true
