extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	if agent.data.assigned_jobs.get("carpenter", null):
		verified = true
