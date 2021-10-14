extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false	
	var stockpile = agent.find_applicable_stockpile("wood")
	if stockpile and Global.resource_nodes.size() < 1:
		
		verified = true
	
			

