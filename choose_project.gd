extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	agent.data.current_project = Global.workstation_orders.carpenters_workbench.pop_back()
	return succeed()
