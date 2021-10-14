extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = _blackboard.data.stock
	print("SUCCESS ON THE STOCKPILE DATA TRANSFER")
	stockpile.action(agent, agent.held)
	print("ACTION SUCCEEDED")
	return succeed()
#	return fail()

