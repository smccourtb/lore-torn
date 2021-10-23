extends BTLeaf


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	# reference to all carpenter's workbenches {carpenters_workbench: {instance id: [projects, ...}, {..}, }
	var orders: Dictionary = Global.workstation_orders.carpenters_workbench
	# get the instance id to an active workstation (carpenters workbench for now)
	# there could be multiple workstations in this list so we just pull thie last
	# out.
	var workstation: int = orders.keys().back()
	# check if it has any projects
	if orders[workstation].empty():
		# delete the reference from the global list
		orders.erase(workstation)
		return fail()
	# if it does, pick the last project in the array and set it to the characters current_project variable
	# this REMOVES the project from the Global list so no others can pick it
	agent.data.current_project = orders[workstation].pop_back()
	# store the workstation reference id to the blackboard, we'll need it for it's position
	blackboard.set_data("target_workstation", workstation)
	# make a copy of the materials list so we can pop it without modifying the referenced list
	blackboard.set_data("material_list", agent.data.current_project.materials.duplicate(true))
	# This turns it black to show its active
#	instance_from_id(workstation).set_modulate(Color(0,0,0))
	return succeed()
