extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var stockpile = _blackboard.data.stock.values()[0]
	stockpile.action(agent, agent.data.inventory.items[0])
	return succeed()

