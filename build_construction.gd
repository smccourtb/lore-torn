extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	#find nearest tree
	var construction = Global.pending_constructions.pop_back()
	construction.build()
	return succeed()