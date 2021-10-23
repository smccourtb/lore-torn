extends KinematicBody2D
class_name CharacterController

var data: Character


export(float) var run_speed = 15.0



# MY OWN TEMP VARS TO REPLACE THE NODE CALLS ( $NodeName )
onready var timer = get_parent().get_node("Timer")
onready var detect = get_node("Area2D")
onready var path_line = get_node("Line2D")
onready var movement = AIMovement.new(self)
# TEMP VARIABLES END 
var velocity: Vector2 = Vector2.ZERO
var path: Array # of Vector2s
var target_direction: Vector2
var target_position # Vector2 or null
onready var pathfinding = get_parent().get_node("Pathfinding")

func get_character_data() -> Character:
	return data
	
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

# Returns the stockpile reference that the item is located in or false
func check_for_stored_item(item_type: String, item_subtype: String = "") -> Dictionary:
	var stockpiles_to_search: Dictionary = find_applicable_stockpiles(item_type, item_subtype)
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
	for i in Global.stockpiles:
		if i.allowed.has(item_type):
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

func find_closest_item(items=Global.items.keys()):
	return find_closest(position, items)

func move_to(pos: Vector2) -> bool:
	path = pathfinding.get_new_path(position, pos)
	set_path_line(path)
	if path.size() > 1:
		var desired_velocity = movement.get_pursue_velocity(path[1],0,0)
		velocity = velocity.linear_interpolate(desired_velocity, .1)
	if position.distance_to(pos) < 8:
		velocity = Vector2.ZERO
		return true
	velocity = move_and_slide(velocity)
	return false

func get_target_position():
	return target_position

func set_target_position(pos: Vector2) -> void:
	self.target_position = pos
