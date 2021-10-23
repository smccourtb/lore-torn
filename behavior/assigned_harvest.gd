extends BTConditional


func _pre_tick(agent: CharacterController, blackboard: Blackboard) -> void:
	verified = false
	var data: Character = agent.get_character_data()
	var assigned_jobs: Array = data.get_assigned_jobs().keys()
	var copy: Array = assigned_jobs.duplicate()
	var harvesting_jobs := {"chop": "tree", "mine": "mineral", "gather": "plant"}
	
	# IDEA: sort by priorty: lowest to highest and pop back
	while !copy.empty():
		var job: String = copy.pop_back()
		for i in harvesting_jobs.keys():
			if job == i:
				var node_type: String = harvesting_jobs.get(i)
				var nodes: Dictionary = Global.get_resource_nodes(node_type)
				if !nodes.empty():
					blackboard.set_data("target_node_type" , node_type)
					verified = true
