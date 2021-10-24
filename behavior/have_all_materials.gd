extends BTConditional


var have_materials: int = 0

func _pre_tick(agent: CharacterController, _blackboard: Blackboard) -> void:
	verified = false
	
	# array of dictionaries with type being the key and the value is a list of subtypes.
	# if empty subtype does not matter
	var materials_needed = agent.data.current_project.materials
	var character_inventory = agent.data.inventory.items.duplicate()
	# i = the type of object ( string )
	for i in materials_needed:
		for j in character_inventory:
			if j:
				if j.get_object_type() == i.keys()[0]:
					character_inventory.erase(j)
					have_materials += 1
			else:
				continue
		
	if have_materials >= materials_needed.size():
		print("I HAVE THE MATERIALS")
		have_materials = 0
		verified = true
