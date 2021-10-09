extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	agent.cut_tree()
	return succeed()
