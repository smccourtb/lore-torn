extends Resource
class_name GAOP

var timer = Timer

func _init(character, root_timer):
	timer = root_timer
	timer.wait_time = .1
	timer.one_shot = true
	goap(character)

func goap_current_state(character):
	var state = ""
	for o in ["axe", "wood", "fruit"]: # List of objects in game world?
		if character.holds(o):
			state += "has_"+o+" sees_"+o+" "
		else:
			state += "!has_"+o+" "
			if character.get_nearest_object(o).object != null:
				state += "sees_"+o+" "
	for o in ["tree", "box"]: # More objects but you cant hold them?
		if character.get_nearest_object(o).object == null:
			state += "!"
		state += "sees_"
		state += o
		state += " "
	state += " hungry" if (character.life < 75) else " !hungry"
	return state

func goap_current_goal(character):
	var goal: String
	if character.count_visible_objects("tree") < 10:
		goal = "sees_growing_tree"
	else:
		goal = "wood_stored"
	goal += " !hungry"
	return goal

func goap(character):
	var action_planner = ActionPlanner.new()
	if action_planner == null:
		return
	while true:
		var plan = action_planner.plan(goap_current_state(character), goap_current_goal(character))
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
			timer.start()
			yield(timer, "timeout")
		timer.start()
		yield(timer, "timeout")
