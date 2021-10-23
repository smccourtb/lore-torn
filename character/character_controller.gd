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

func get_neighbors() -> Array:
	return detect.get_overlapping_bodies()

func get_move_speed() -> float:
	return 3.0 * run_speed
	
func set_path_line(points: Array):
	# Used for debug purposes
	var local_points:= []
	for point in points:
		local_points.append(point - global_position)
	path_line.points = local_points

func pickup(object):
	object.get_parent().remove_child(object)
	data.inventory.add_item(object)

func find_closest_item(items=Global.items.keys()):
	return find_closest(position, items)

# Returns the stockpile reference that the item is located in or false
func check_for_stored_item(item_type: String, item_subtype: String = "") -> Dictionary:
	var stockpiles_to_search: Dictionary
	if !item_subtype:
		stockpiles_to_search = find_applicable_stockpiles(item_type)
	else:
		stockpiles_to_search = find_applicable_stockpiles(item_type, item_subtype)
	while !stockpiles_to_search.empty():
		var closest = find_closest(position, stockpiles_to_search.keys()).values()[0]
		for i in stockpiles_to_search.values():
			if i.rect.position == closest:
				var search = check_stockpile_for_item(item_type, i, item_subtype)
				stockpiles_to_search.erase(i)
				if search:
					return {search: i} 
	return {}
		
func find_applicable_stockpiles(item_type: String, item_subtype: String = "") -> Dictionary:
	# Returns a dictionary stockpiles {starting_position_of_stockpile: stockpile}
	var applicable: = {}
	# for each stockpile
	for i in Global.stockpiles:
		# check if there is a key that matches item_type
		if i.allowed.has(item_type):
			# if no subtype provided than add 
			# {start_pos of stockpile (grid coord): stockpile reference}
			if !item_subtype:
				applicable[i.get_start_coord()] = i
			else:
				# check if subtype is allowed in stockpile or if its an empty array
				if i.allowed[item_type].empty() || item_subtype in i.allowed[item_type]:
					applicable[i.get_start_coord()] = i
	return applicable

func check_stockpile_for_item(item_type: String, stockpile: Stockpile, item_subtype: String = ""):
	for j in stockpile.items:
		if !j:
			continue
		if !item_subtype:
			if j.get_object_type() == item_type:
				return j
		else:
			if j.get_object_subtype() == item_subtype:
				return j
	return false

# finds the closest object to position in an array of vector2s
func find_closest(starting_position:Vector2, array_to_search: Array):
	starting_position = Global.map_grid.calculate_grid_coordinates(starting_position)
	var closest_object
	var dic = {}
	
	if !array_to_search.empty():
		for i in array_to_search:
			var distance = i.distance_squared_to(starting_position)
			if !closest_object:
				closest_object = distance
			else:
				if distance < closest_object:
					closest_object = distance
			dic[distance] = i
		closest_object = dic.keys().min()
		# returns {distance : position}
		return {closest_object: dic[closest_object]}
	return {}


# generates an arry of strings that represent object types from a dictionary of materials and their amounts
func convert_material_list(material_dict):
	var material_list = []
	for i in material_dict.keys():
		for _j in range(material_dict[i]):
			material_list.append(i)
	print("MATERIAL LIST: ", material_list)
	return material_list


###########################33

#const N = 1
#const E = 2
#const S = 4
#const W = 8
## Used for check_neighbor() function
#var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
#				  Vector2(0, 1): S, Vector2(-1, 0): W}
#
#func check_neighbors(cell, unvisited):
#	# returns an array of cell's unvisited neighbors
#	var list = []
#	for n in cell_walls.keys():
#		if cell + n in unvisited:
#			list.append(cell + n)
#	return list


#func find_nodes(starting_position: Vector2, item_type: String):
##	populates unvisited array by looping through entire map
#
#	var closest_object:= {}
#	var unvisited = []  # array of unvisited tiles
#	var stack = []
#	for x in range(Global.chunk_grid.size.x):
#		for y in range(Global.chunk_grid.size.y):
#			unvisited.append(Vector2(x, y))
#	var current = Global.chunk_grid.calculate_grid_coordinates(starting_position)
#	unvisited.erase(current)
##
##	# execute recursive backtracker algorithm
#	while !closest_object:
#		if closest_object.empty():
#			closest_object = search_chunk(starting_position, current, item_type)
#		var d = search_chunk(starting_position, current, item_type)
#		if !d.empty():
#			if d.keys()[0] < closest_object.keys()[0]:
#				closest_object = d
#		var neighbors = check_neighbors(current, unvisited)
#		if neighbors.size() > 0:
#			var next = neighbors[randi() % neighbors.size()]
#			stack.append(current)
#			current = next
#			unvisited.erase(current)
#		elif stack:
#			current = stack.pop_back()
#
#	return closest_object.values()[0]
