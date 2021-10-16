extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var action_performed = agent.cut_tree()
	if action_performed:
		return succeed()
	return fail()
