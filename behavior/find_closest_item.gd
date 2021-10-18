extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var items_on_ground = Global.items.duplicate()
	while !items_on_ground.empty():
		# get the pos of the closest item in a copy of Global.items
		var closest_item_pos = agent.find_closest_item(items_on_ground.keys()).values()[0]
		# store the item in this variable
		var item_to_haul = items_on_ground[closest_item_pos]
		# erase key/value pair from the copied dict
		items_on_ground.erase(closest_item_pos)
		# check if item is selected, if so, skip this iteration because that is someone elses target
		var item = instance_from_id(item_to_haul)
		if item.selected:
			print("Item is already selected, choosing next closest position")
			continue
		# search all stockpiles to see if there is a stockpile that will accept the the closest item to us
		# IF we went for it. we just need to know its not a wasted trip if we cant store it
		var stockpile = agent.find_applicable_stockpiles(item.get_object_type(), item.get_object_subtype())
		if !stockpile.empty():
			# if it found stockpiles, find the closest one and store it
			var closest = agent.find_closest(agent.position, stockpile.keys())
			# Erase it from the global list so no one else can pick it
			Global.items[closest_item_pos].selected = true
			agent.target_position = Global.map_grid.calculate_map_position(closest.rect.position)
			return succeed()
	return fail()
		# if not the repeat the process until it runs out of items thst can be stored
	
	
	
