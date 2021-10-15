extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	var resources = {"chop": "tree", "mine": "mineral", "gather": "plant"}
	var stockpile = agent.find_applicable_stockpile("wood")
	for i in agent.data.assigned_jobs:
		if i in resources.keys():
			if stockpile and Global.resource_nodes[resources[i]].size() < 1:
		
				verified = true
	
			

