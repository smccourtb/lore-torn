extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false	
	if Global.stockpiles.size() > 0 and Global.resource_nodes.size() < 1:
		
		verified = true
	
			

