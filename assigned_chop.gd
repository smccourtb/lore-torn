extends BTConditional


func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	for jobs in agent.data.assigned_jobs:
		if jobs == "chop":
			verified = true
		else:
			verified = false	
