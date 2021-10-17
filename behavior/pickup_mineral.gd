extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	agent.pickup_nearest_object("mineral")
	return succeed()
