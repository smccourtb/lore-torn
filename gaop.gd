extends Resource
class_name GAOP

func goap_current_state():
	var state = ""
	for o in ["axe", "wood", "fruit"]:
		if holds(o):
			state += "has_"+o+" sees_"+o+" "
		else:
			state += "!has_"+o+" "
			if get_nearest_object(o).object != null:
				state += "sees_"+o+" "
	for o in ["tree", "box"]:
		if get_nearest_object(o).object == null:
			state += "!"
		state += "sees_"
		state += o
		state += " "
	state += " hungry" if (life < 75) else " !hungry"
	return state

func goap_current_goal():
	var goal
	if count_visible_objects("tree") < 10:
		goal = "sees_growing_tree"
	else:
		goal = "wood_stored"
	goal += " !hungry"
	return goal

func goap():
	var action_planner = get_node("ActionPlanner")
	if action_planner == null:
		return
	while true:
		var plan = action_planner.plan(goap_current_state(), goap_current_goal())
		# execute plan
		for a in plan:
			var error = false
			# Actions are implemented as methods
			# - immediate actions return a boolean status
			# - non immediate actions (that call yield) send their status using the action_end signal
			if has_method(a):
				print("Calling action function "+a)
				var status = call(a)
				if typeof(status) == TYPE_OBJECT and status is GDScriptFunctionState:
					status = yield(self, "action_end")
				if typeof(status) != TYPE_BOOL:
					print("Return value of "+a+" is not a boolean")
					status = false
				error = !status
			else:
				print("Cannot perform action "+a)
				error = true
			if error: break
			$Timer.start()
			yield($Timer, "timeout")
		$Timer.start()
		yield($Timer, "timeout")
