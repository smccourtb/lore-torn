extends BTConditional


func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	verified = false	
	for jobs in agent.data.assigned_jobs:
		if jobs == "mine":
			verified = true
	
