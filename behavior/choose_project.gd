extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	# get the reference to an active workstation (carpenters workbench for now)
	var workstation = Global.workstation_orders.carpenters_workbench.keys().pop_back()
	# check if it has any projects
	if Global.workstation_orders.carpenters_workbench[workstation].empty():
		# if not delete the reference from the global list
		Global.workstation_orders.carpenters_workbench.erase(workstation)
		return fail()
	# if it does, pick the last project in the array and set it to the characters current_project variable
	# this REMOVES the project from the Global list so no others can pick it
	agent.data.current_project = Global.workstation_orders.carpenters_workbench[workstation].pop_back()
	# store the workstation reference to the blackboard, we'll need it for it's position
	_blackboard.data["target_workstation"] = workstation
	return succeed()
