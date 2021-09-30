extends Node2D

# contains all information of character
var data: Character
onready var time = get_parent().time

# TEMP VARIABLES #

export(float) var run_speed = 10.0

var motion = Vector3(0, 0, 0)
var previous_position = Vector3(0, 0, 0)
var blocked_time = 0.0
var target = null
var life = 100.0
var gaop: GAOP
var held = null # This represents one handed item being equipped.

signal run_end
signal action_end


# MY OWN TEMP VARS TO REPLACE THE NODE CALLS ( $NodeName )

onready var detect = get_node("Area2D")

# TEMP VARIABLES END 

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_G:
			#This triggers the AI to start doing its thang
			if !gaop:
				gaop = GAOP.new(self, get_parent().get_node('Timer'))
				
func run_to(p):
	blocked_time = 0.0
	target = p

func get_nearest_object(object_type = null):
	# FINDS nearest object or CHECK for specified object
	var nearest_distance = 100
	var nearest_object = null
	for o in detect.get_overlapping_bodies():
		if o.is_inside_tree():
			var distance = (global_transform.origin - o.global_transform.origin).length()
			if o != self and o.get_script() != null and (object_type == null or o.get_object_type() == object_type) and distance < nearest_distance:
				nearest_distance = distance
				nearest_object = o
	return { object=nearest_object, distance=nearest_distance }

func count_visible_objects(object_type):
	# TODO: Just look up global list for objects and populate it on start up
	var count = 0
	for o in detect.get_overlapping_bodies():
		if o.is_inside_tree():
			var distance = (global_transform.origin - o.global_transform.origin).length()
			if o != self and o.get_script() != null and o.get_object_type() == object_type:
				count += 1
	return count


func holds(object_type):
	if held != null and held.get_object_type() == object_type:
		return true
	return false

func pickup_object(object_type):
	var nearest = get_nearest_object(object_type)
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
	var object = get_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.translation) # object.position
	if !yield(self, "run_end"):
		emit_signal("action_end", false)
	emit_signal("action_end", pickup_object(object_type))

func pickup_axe():
	return pickup_nearest_object("axe")

func pickup_wood():
	return pickup_nearest_object("wood")
	


func use_nearest_object(object_type):
	var object = get_nearest_object(object_type).object
	if object == null:
		return false
	run_to(object.translation) # object.position
	if !yield(self, "run_end"):
		emit_signal("action_end", false)
	emit_signal("action_end", object.action(self))

func cut_tree():
	return use_nearest_object("tree")

func wait():
	# The wait action triggers an error so the plan is recalculated 
	return false
