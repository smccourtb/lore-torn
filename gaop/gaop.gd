extends Resource
class_name GAOP

var timer = Timer

func _init(character, root_timer):
	timer = root_timer
	timer.wait_time = .1
	timer.one_shot = true
	goap(character)

func get_goap_current_state():
	var state = ""
	for o in ["axe", "wood", "fruit"]:
		if holds(o):
			state += "has_"+o+" sees_"+o+" "
		else:
			state += "!has_"+o+" "
			if find_nearest_object(o).object != null:
				state += "sees_"+o+" "
	for o in ["tree", "box"]:
		if find_nearest_object(o).object == null:
			state += "!"
		state += "sees_"
		state += o
		state += " "
	state += " hungry" if (life < 75) else " !hungry"
	return state

func get_goap_current_goal():
	var goal
	# the goal is to plant trees then gather wood when there are enough trees
	if count_visible_objects("tree") < 10:
		goal = "sees_growing_tree"
	else:
		goal = "wood_stored"
	# in any case, avoid starvation
	goal += " !hungry"
	return goal

func goap():
	var start_time = OS.get_unix_time()
	var count = 0
	var action_planner = get_node("ActionPlanner")
	if action_planner == null:
		return
	while true:
		count += 1
		print("%d: Planning (%d)..." % [ OS.get_unix_time() - start_time, count ])
		var plan : Array = action_planner.plan(get_goap_current_state(), get_goap_current_goal())
		$UI/ActionQueue.text = PoolStringArray(plan).join(", ")
		# execute plan
		for a in plan:
			var error = false
			# Actions are implemented as methods
			# - immediate actions return a boolean status
			# - non immediate actions (that call yield) return a GDScriptFunctionState
			if has_method(a):
				print("Calling action function "+a)
				var status = call(a)
				while status is GDScriptFunctionState:
					status = yield(status, "completed")
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
