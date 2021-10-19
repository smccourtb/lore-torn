extends BTConditional


func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	verified = false	
	if agent.data.assigned_jobs.get("mine", null):
		verified = true
	
