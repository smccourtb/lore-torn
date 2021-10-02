extends KinematicBody2D
export var arrival_distance: int # How far away to begin circling?
#export var pursuit_deadzone: float = rand_range(12.0, 48.0) 
# contains all information of character
var data: Character
#onready var time = get_parent().time

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
	pass
	
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
#			emit_signal("run_end", false)
		if position.distance_to(target_position) < 15:
			
			velocity = Vector2.ZERO
			target_position = null
			emit_signal("run_end", true)
	velocity = move_and_slide(velocity)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_G:
#			#This triggers the AI to start doing its thang
			goap()

	
func run_to(p):
	target_position = p
	target_direction = target_position - position
	

func find_nearest_object(object_type = null):
	var nearest_distance = 10000000
	var nearest_object = null
	# TODO: look to global list of OBJECT_TYPE
	for o in Global.resource_nodes:
		var distance = position.distance_to(o.position)
		if !(o is KinematicBody2D):
			if o != self and o.get_script() != null and (object_type == null or o.get_object_type() == object_type) and distance < nearest_distance:
				nearest_distance = distance
				nearest_object = o
	return { object=nearest_object, distance=nearest_distance }


func count_visible_objects(object_type):
	# TODO: Just look up global list for objects and populate it on start up
	var count = 0
	for o in detect.get_overlapping_bodies():
		if o.is_inside_tree():
			var distance = position.distance_to(o.position)
			if o != self and o.get_script() != null and o.get_object_type() == object_type:
				count += 1
	return count

func holds(object_type):
	if held != null and held.get_object_type() == object_type:
		return true
	return false
	
func pickup_object(object_type):
	var nearest = find_nearest_object(object_type)
	if nearest.object == null or nearest.distance > 1.0:
		return false
	pickup(nearest.object)
	return true

func pickup(object):
	if held != null:
		get_parent().add_child(held)
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
	var object = find_nearest_object(object_type).object
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
	var object = find_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.position)
	if !yield(self, "run_end"):
		return false
	return object.action(self)

func cut_tree():
	return use_nearest_object("tree")


func get_goap_current_state():
	print("GETTING CURRENT STATE")
	var state = ""
	# Check assigned jobs for what to do
	for i in Global.jobs:
		
		if data.assigned_jobs.find(i) == -1:
			state += "!assigned_"+i+" "
		else:
			state += "assigned_"+i+" "
#	for o in ["axe"]:  # , "wood", "fruit"
#		if holds(o):
#			state += "has_"+o+" sees_"+o+" "
#		else:
#			state += "!has_"+o+" "
#			if find_nearest_object(o).object != null:
#				state += "sees_"+o+" "
	for o in ["tree"]:  # , "box"
		if Global.resource_nodes.size() < 1:
#		if find_nearest_object(o).object == null:
			state += "!"
		state += "sees_"
		state += o
		state += " "
	state += " !hungry" #if (life < 75) else " !hungry"
	state += " !tired" if (data.energy_level > 25) else " tired"
	print(state)
	return state

func get_goap_current_goal():
	var goal
	# the goal is to plant trees then gather wood when there are enough trees
	#if count_visible_objects("tree") < 10:
	goal = "!assigned_chop"
#	else:
#		goal = "wood_stored"
	# in any case, avoid starvation
	goal += " !hungry"
	goal += " !tired"
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
		print('PLAN: ', plan)
		# execute plan
		for a in plan:
			var error = false
			# Actions are implemented as methods
			# - immediate actions return a boolean status
			# - non immediate actions (that call yield) return a GDScriptFunctionState
			if has_method(a):
				print("Calling action function "+a)
				var status = call(a)
				print("STATUS: ", status)
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
