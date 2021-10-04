extends KinematicBody2D
var data: Character
var goals: = {"basic needs": [ " !tired", " !hungry", " !thirsty"],
			  "jobs": ["chop", "mine", "gather"]}   

# TEMP VARIABLES #

export(float) var run_speed = 15.0
var held = null
signal run_end
signal action_end


# MY OWN TEMP VARS TO REPLACE THE NODE CALLS ( $NodeName )
onready var timer = get_parent().get_node("Timer")
onready var detect = get_node("Area2D")
onready var path_line = get_node("Line2D")
onready var movement = AIMovement.new(self)
# TEMP VARIABLES END 
var velocity: Vector2 = Vector2.ZERO
var path: Array
var target_direction: Vector2
var target_position
var pathfinding: PathFinding


func _ready() -> void:
	SignalBus.connect("resource_removed", self, "_on_ResouceRemoved")

func _on_ResouceRemoved(ref, target):
	if target_position:
		if target_position.is_equal_approx(ref.position):
			print("YYEEEEEEEEEEEEEESSSSSSSSSSSSSSS pick a new target bud.")
			use_nearest_object(target)
		
func get_neighbors() -> Array:
	return detect.get_overlapping_bodies()

func get_move_speed() -> float:
	return 3.0 * run_speed
	
func set_path_line(points: Array):
	var local_points:= []
	for point in points:
		local_points.append(point - global_position)
	path_line.points = local_points

func _physics_process(_delta):
	if target_position:
		path = pathfinding.get_new_path(position, target_position)
		set_path_line(path)
#		if path.size() > 1:
		var desired_velocity = movement.get_pursue_velocity(target_position,0,0)
		velocity = velocity.linear_interpolate(desired_velocity, 0.1)
		
		if position.distance_to(target_position) < 15:
			
			velocity = Vector2.ZERO
#			target_position = null
			emit_signal("run_end", true)
		else:
			emit_signal("run_end", false)
	velocity = move_and_slide(velocity)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_G:
#			#This triggers the AI to start doing its thang
			goap()

	
func run_to(p):
	target_position = p
	target_direction = target_position - position
	

func find_nearest_object(object_type = null, arr:= []):
	var nearest_distance = 10000000
	var nearest_object = null
	# TODO: look to global list of OBJECT_TYPE
	for o in arr:
		var distance = position.distance_to(o.position)
		if !(o is KinematicBody2D) || o is Collectable:
			if o != self and o.get_script() != null and (object_type == null or o.get_object_type() == object_type) and distance < nearest_distance:
				nearest_distance = distance
				nearest_object = o
	return { object=nearest_object, distance=nearest_distance }

func holds(object_type):
	if held != null and held.get_object_type() == object_type:
		return true
	return false
	
func pickup_object(object_type):
	var nearest = find_nearest_object(object_type, Global.items[object_type])
	if nearest.object == null : #or nearest.distance > 1.0:
		return false
	pickup(nearest.object)
	return true

func pickup(object):
	if held != null:
		get_parent().add_child(held)
	SignalBus.emit_signal("resource_removed", object, object.get_object_type())
	Global.items[object.get_object_type()].erase(object)
	object.get_parent().remove_child(object)
	held = object
	

func store_held(object_type):
	if held != null && held.get_object_type() == object_type:
		held = null
		return true
	else:
		return false
		

# Actions for GOAP

func pickup_nearest_object(object_type):
	if holds(object_type):
		return false
	var object = find_nearest_object(object_type, Global.items[object_type]).object
	if object == null:
		return false
	run_to(object.position)

	if !yield(self, "run_end"):
		return false
	return pickup_object(object_type)

func pickup_axe():
	return pickup_nearest_object("axe")

func pickup_wood():
	return pickup_nearest_object("wood")

func use_nearest_object(object_type: String):
	var object = find_nearest_object(object_type, Global.resource_nodes).object
	if object == null:
		return false
	run_to(object.position)
	if !yield(self, "run_end"):
		return false
	return object.action(self)

func cut_tree():
	return use_nearest_object("tree")

func store_wood():
	# TODO: change to find_applicable_stockpile(specific item)
	return find_applicable_stockpile("wood")

func find_applicable_stockpile(what: String):
	for i in Global.stockpiles:
		if what in i.allowed:
			run_to(i.slot_coords[Util.randi_range(0,i.slot_coords.size()-1)])
			print("SHOULD BE RUNNING TO STOCKPILE NOW")
			if !yield(self, "run_end"):
				print("CAUGHT IN HERER TTTTTTTTTTTTTTTTTTTTTTT")
				return false
			print('CAllING the ACTION DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd')
			return i.action(self, held)
			
func get_goap_current_state() -> String:
	var state = ""
	# Check assigned jobs for what to do
	for i in Global.jobs:
		# if the job isnt assigned to the character
		if data.assigned_jobs.find(i) == -1:
			state += " !assigned_" + i
		else:
			state += " assigned_" + i
	# Represents items on the ground
	for i in ["wood"]:
		if holds(i):
			state += " has_"+i+" sees_"+i
		else:
			state += " !has_"+i
			if Global.items.has(i) and Global.items[i].size() > 0:
				if find_nearest_object(i, Global.items[i]).object != null:
					state += " sees_"+i

	for o in ["tree"]:
		if Global.resource_nodes.size() < 1:
				state += " !sees_"+o
		else:
			state += " sees_"+o
	
	if Global.stockpiles.size() > 0:
		state += " sees_stockpile"
	else:
		state += " !sees_stockpile"
	state += " !hungry" #if (life < 75) else " !hungry"
	state += " !tired" if (data.energy_level > 25) else " tired"
	state += " !thirsty"
	print(state)
	return state

func get_goap_current_goal():
	var goal = ""
	
	# the goal is to plant trees then gather wood when there are enough trees
	#if count_visible_objects("tree") < 10:
	goal += " wood_stored"
#	print("GOAL: ", goal)
	for i in goals['basic needs']:
		goal += i
#	else:
#		goal = "wood_stored"
	# in any case, avoid starvation
#	goal += " !hungry"
#	goal += " !tired"
	return goal

func goap():
	# makes a plan based on current state and current goal
	# loops through plan (list of actions) and performs each one
	# if any of the actions returns false it breaks out and makes a new plan.
	var start_time = OS.get_unix_time()
	var count = 0
	var action_planner = get_node("ActionPlanner")
	if action_planner == null:
		return
	while true:
		count += 1
		print("%d: Planning (%d)..." % [ OS.get_unix_time() - start_time, count ])
		var plan : Array = action_planner.plan(get_goap_current_state(), get_goap_current_goal())
		print('PLAN: ', plan)
		# execute plan
		for a in plan:
			var error = false
			# Actions are implemented as methods. meaning each actions needs a matching function to call
			# - immediate actions return a boolean status
			# - non immediate actions (that call yield) return a GDScriptFunctionState
			if has_method(a):
				print("Calling action function "+a)
				# calls the current action method
				var status = call(a)
				$Label.text = Util.titlefy(a)
				# While action method is being performed wait for completion. expecting
				# a return of true or false
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
			timer.start()
			yield(timer, "timeout")
		timer.start()
		yield(timer, "timeout")
