extends BTConditional


var have_materials: bool = false

func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	
	# dictionary of needed materials with type being the keys and amount being the value
	var materials_needed = agent.data.current_project.materials
	var character_inventory = agent.data.inventory.items
	# i = the type of object ( string )
	var count: int = 0
	for i in materials_needed.keys():
		print("MATERIAL NEEDED: ", i)
		for j in character_inventory:
			print("ITEM IN INVENTORY: ", j)
			if j:
				if j.get_object_type() == i:
					count += 1
				if count == materials_needed[i]:
					have_materials = true
				else:
					have_materials = false
		count = 0
		
	if have_materials:
		print("I HAVE THE MATERIALS")
		verified = true
