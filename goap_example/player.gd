extends KinematicBody

export(float) var run_speed = 10.0

var motion = Vector3(0, 0, 0)
var previous_position = Vector3(0, 0, 0)
var blocked_time = 0.0
var target = null
var life = 100.0

var held = null

signal run_end
signal action_end

func _ready():
	pass

func _physics_process(delta):
	# no help
	pass

func run_to(p):
	blocked_time = 0.0
	target = p

func get_nearest_object(object_type = null):
	var nearest_distance = 100
	var nearest_object = null
	for o in $Detect.get_overlapping_bodies():
		if o.is_inside_tree():
			var distance = (global_transform.origin - o.global_transform.origin).length()
			if o != self and o.get_script() != null and (object_type == null or o.get_object_type() == object_type) and distance < nearest_distance:
				nearest_distance = distance
				nearest_object = o
	return { object=nearest_object, distance=nearest_distance }

func count_visible_objects(object_type):
	var count = 0
	for o in $Detect.get_overlapping_bodies():
		if o.is_inside_tree():
			var distance = (global_transform.origin - o.global_transform.origin).length()
			if o != self and o.get_script() != null and o.get_object_type() == object_type:
				count += 1
	return count


func holds(object_type):
	if held != null and held.get_object_type() == object_type:
		return true
	return false

func update_held_icon():
	if held == null || name != "Player":
		$UI/Held.visible = false
	else:
		$UI/Held.visible = true
		$UI/Held.texture = load("res://goap_example/"+held.get_object_type()+"/"+held.get_object_type()+".png")

func pickup_object(object_type):
	var nearest = get_nearest_object(object_type)
	if nearest.object == null or nearest.distance > 1.0:
		return false
	pickup(nearest.object)
	return true

func pickup(object):
	if held != null:
		get_parent().add_child(held)
		held.translation = translation + Vector3(0.0, 1.0, 1.0).rotated(Vector3(0.0, 1.0, 0.0), rotation.y)
		held.apply_impulse(Vector3(0.0, 0.0, 0.0), Vector3(0.0, 1.0, 1.0).rotated(Vector3(0.0, 1.0, 0.0), rotation.y))
	object.get_parent().remove_child(object)
	held = object
	update_held_icon()

func store_held(object_type):
	if held != null && held.get_object_type() == object_type:
		held = null
		update_held_icon()
		return true
	else:
		return false

# Actions for GOAP

func pickup_nearest_object(object_type):
	if holds(object_type):
		return false
	var object = get_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.translation)
	if !yield(self, "run_end"):
		emit_signal("action_end", false)
	emit_signal("action_end", pickup_object(object_type))

func pickup_axe():
	return pickup_nearest_object("axe")
	
func pickup_fruit():
	return pickup_nearest_object("fruit")
	
func pickup_wood():
	return pickup_nearest_object("wood")

func use_nearest_object(object_type):
	var object = get_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.translation)
	if !yield(self, "run_end"):
		emit_signal("action_end", false)
	emit_signal("action_end", object.action(self))

func cut_tree():
	return use_nearest_object("tree")
	
func store_wood():
	return use_nearest_object("box")

func eat_fruit():
	if held != null and held.get_object_type() == "fruit":
		held.free()
		held = null
		update_held_icon()
		life += 20
		if life > 100: life = 100
		return true
	return false

func do_grow_tree():
	pass

func grow_tree():
	# Check we have a fruit
	if held == null or held.get_object_type() != "fruit":
		return false
	# Find a nice location for the tree
	var box = get_node("../Box")
	var p = null
	for i in range(5, 100, 5):
		for j in range(10):
			var test_p = Vector3(rand_range(-i, i), 0.0, rand_range(-i, i))
			var ok = true
			for c in get_parent().get_children():
				if (c == box or c.has_method("get_object_type") and c.get_object_type().left(4) == "tree") and (c.translation - test_p).length() < 5.0:
					ok = false
			if ok:
				p = test_p
				break
		if p != null:
			break
	# return false if no location was found
	if p == null:
		return false
	# Try to run to location and return false uon failure
	run_to(p)
	if !yield(self, "run_end"):
		emit_signal("action_end", false)
	# Destroy fruit and create growing tree
	emit_signal("action_end", do_grow_tree())

func wait():
	# The wait action triggers an error so the plan is recalculated 
	return false

# GOAP stuff

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
		$UI/ActionQueue.text = PoolStringArray(plan).join(", ")
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
