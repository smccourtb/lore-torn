extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = _blackboard.data.stock
	stockpile.action(agent, agent.held)
	return succeed()
