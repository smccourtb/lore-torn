extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
	agent.cut_tree()
	return succeed()
