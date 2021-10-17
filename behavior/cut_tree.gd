extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var action_performed = agent.use_nearest_object("tree")
	if action_performed:
		return succeed()
	return fail()
