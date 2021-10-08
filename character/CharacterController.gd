extends KinematicBody2D
var data: Character
var goals: = {"basic needs": [ " !tired", " !hungry", " !thirsty"],
			  "jobs": ["chop", "mine", "gather"]}   

# TEMP VARIABLES #

export(float) var run_speed = 15.0
var held = null

signal run_end
# warning-ignore:unused_signal
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
# warning-ignore:return_value_discarded
	SignalBus.connect("resource_removed", self, "_on_ResouceRemoved")

func _on_ResouceRemoved(ref, target):
	if target_position:
		if target_position.is_equal_approx(ref.position):
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
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_G:
#			#This triggers the AI to start doing its thang
			pass

	
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
	if nearest.object == null or nearest.distance >= 15.0:
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
	return object.action(self)

func cut_tree():
	return use_nearest_object("tree")

func store_wood():
	# TODO: change to find_applicable_stockpile(specific item)
	return find_applicable_stockpile("wood")

func find_applicable_stockpile(what: String):
	for i in Global.stockpiles:
		if what in i.allowed and !i.check_if_full():
			run_to(i.slot_coords[Util.randi_range(0,i.slot_coords.size()-1)])
			if !yield(self, "run_end"):
				return false
			return i.action(self, held)
	return false
