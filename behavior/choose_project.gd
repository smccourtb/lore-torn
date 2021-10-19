extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	var workstation = instance_from_id(Global.workstation_orders.carpenters_workbench.keys().pop_back())
	print("WORKSTATION CHOICE: ", workstation)
	agent.data.current_project = workstation.pop_back()
	return succeed()
