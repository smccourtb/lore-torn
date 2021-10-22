extends BTConditional


func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	verified = false
	var assigned_jobs_copy = agent.data.assigned_jobs.keys().duplicate()
	var harvesting_jobs = {"chop": "tree", "mine": "mineral", "gather": "plant"}
	while !assigned_jobs_copy.empty():
		var job = assigned_jobs_copy.pop_back()
		for i in harvesting_jobs.keys():
			if job == i:
				if !Global.resource_nodes[harvesting_jobs[i]].empty():
					blackboard.set_data("target_node_type" , harvesting_jobs[i])
					verified = true
	
			
