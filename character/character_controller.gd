extends KinematicBody2D

var data: Character


export(float) var run_speed = 15.0



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
onready var pathfinding = get_parent().get_node("Pathfinding")


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


func pickup_object(object_type):
	var nearest = find_nearest_object(object_type, Global.items[object_type])
	if nearest.object == null:
		return false
	pickup(nearest.object)
	return true

func pickup(object):
#	if held != null:
#		get_parent().add_child(held)
	Global.items[object.get_object_type()].erase(object)
	object.get_parent().remove_child(object)
#	held = object

# Actions for GOAP

func pickup_nearest_object(object_type):
	var object = find_nearest_object(object_type, Global.items[object_type]).object
	if object == null:
		return false
	return pickup_object(object_type)

func use_nearest_object(object_type: String):
	var object = find_nearest_object(object_type, Global.resource_nodes[object_type]).object
	if object == null:
		return false
	return object.action(self)

func find_nearest_object(object_type = null, arr:= []):
	var nearest_distance = 10000000
	var nearest_object = null
	# TODO: look to global list of OBJECT_TYPE
	for o in arr:
		var distance = position.distance_to(o.position)
		if !(o is KinematicBody2D) || o is Item:
			if o != self and o.get_script() != null and (object_type == null or o.get_object_type() == object_type) and distance < nearest_distance:
				nearest_distance = distance
				nearest_object = o
	return { object=nearest_object, distance=nearest_distance }

func find_applicable_stockpile(item_type: String):
	for i in Global.stockpiles:
		if item_type in i.allowed:
			if !i.check_if_full():
				return i

func check_stockpile_for_item(what: String):
	for i in Global.stockpiles:
		for j in i.items:
			if j.get_object_type() == what:
				return i

# generates an arry of strings that represent object types from a dictionary of materials and their amounts
func convert_material_list(material_dict):
	var material_list = []
	for i in material_dict.keys():
		for j in range(material_dict[i]):
			material_list.append(i)
	return material_list
		
###########################33

const N = 1
const E = 2
const S = 4
const W = 8
# Used for check_neighbor() function
var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}
				
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list


func find_nodes(starting_position: Vector2, item_type: String):
#	populates unvisited array by looping through entire map

	var closest_object:= {}
	var unvisited = []  # array of unvisited tiles
	var stack = []
	for x in range(Global.chunk_grid.size.x):
		for y in range(Global.chunk_grid.size.y):
			unvisited.append(Vector2(x, y))
	var current = Global.chunk_grid.calculate_grid_coordinates(starting_position)
	unvisited.erase(current)
#
#	# execute recursive backtracker algorithm
	while !closest_object:
		if closest_object.empty():
			closest_object = search_chunk(starting_position, current, item_type)
		var d = search_chunk(starting_position, current, item_type)
		if !d.empty():
			if d.keys()[0] < closest_object.keys()[0]:
				closest_object = d
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()

	return closest_object.values()[0]


func search_chunk(starting_position:Vector2, chunk_position:Vector2, item_type: String):
	var closest_object
	var dic = {}
	if !Global.map_data[chunk_position][item_type].empty() and Global.chunk_grid.is_within_bounds(chunk_position):
		for i in Global.map_data[chunk_position][item_type]:
			var distance = i.distance_squared_to(starting_position)
			if !closest_object:
				closest_object = distance
			else:
				if distance < closest_object:
					closest_object = distance
			dic[distance] = i
		var c = dic.keys()
		closest_object = dic.keys().min()
		return {closest_object: dic[closest_object]}
	return {}
