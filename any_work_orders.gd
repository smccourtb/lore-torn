extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false	
	if Global.workstation_orders.carpenters_workbench.size() > 0:
			verified = true
