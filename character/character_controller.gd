extends KinematicBody2D
class_name CharacterController

var data: Character

# TODO: should be based on genetics and energy; Make it dynamic
export(float) var run_speed = 15.0

onready var timer = get_parent().get_node("Timer")
onready var detect = get_node("Area2D")
onready var path_line = get_node("Line2D")
onready var movement = AIMovement.new(self)
var velocity: Vector2 = Vector2.ZERO
var path: Array # of Vector2s
var target_direction: Vector2
var target_position # Vector2 or null
onready var pathfinding = get_parent().get_node("Pathfinding")

# for when the camera follows and shows stats
var targeted: bool = false

# Things I need to know - personality stuff
# what objects are in my proximity
var objects_near_me: Array
	# various attributes of those objects to see their quality and stuff
# what characters are in my proximity
var characters_near_me: Array
	# what emotion those characters are in
	# what traits those characters have
# tile im on / whats in my area -> for a character that gets in a good mood for standing on grass
# running controller of interactions I can have and the ones ive had

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
#	pathfinding.update_navigation_map([Global.map_grid.calculate_grid_coordinates(object.position)])
	Global.items.erase(Global.map_grid.calculate_grid_coordinates(object.position))
	object.get_parent().remove_child(object)
	data.inventory.add_item(object)
	object.set_selected(false)
	print("items in inventory: ", data.inventory.get_items())

# Returns the stockpile reference that the item is located in or false
func check_for_stored_item(item_type: String, item_subtype: String = "") -> Dictionary:
	var stockpiles_to_search: Dictionary = find_applicable_stockpiles(item_type, item_subtype)
	while not stockpiles_to_search.empty():
		var closest = find_closest(position, stockpiles_to_search.keys()).values()[0]
		for stockpile in stockpiles_to_search.values():
			if stockpile.get_start_coord() == closest:
				stockpiles_to_search.erase(stockpile)
				var item: Dictionary = stockpile.check_for_item(item_type, item_subtype)
				if not item.empty():
					return stockpile
	return {}
		
func find_applicable_stockpiles(item_type: String, item_subtype: String = "") -> Dictionary:
	# Returns a dictionary stockpiles {starting_position_of_stockpile: stockpile}
	var applicable: = {}
	for stockpile in Global.stockpiles:
		if stockpile.allowed.has(item_type):
			if !item_subtype:
				applicable[stockpile.get_start_coord()] = stockpile
			else:
				# check if subtype is allowed in stockpile or if its an empty array
				if stockpile.allowed[item_type].empty() or item_subtype in stockpile.allowed[item_type]:
					applicable[stockpile.get_start_coord()] = stockpile
	return applicable

# finds the closest object to position in an array of vector2s
func find_closest(starting_position:Vector2, array_to_search: Array) -> Dictionary:
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
	path = pathfinding.get_new_path(global_position, pos)
	set_path_line(path)
	if path.size() > 1:
#		var desired_velocity: Vector2 = movement.get_pursue_velocity(path[1],0,0)
#		velocity = velocity.linear_interpolate(desired_velocity, .1)
		velocity = global_position.direction_to(path[1]) * (run_speed * 3)
		
	if global_position.distance_to(pos) < 1:
		velocity = Vector2.ZERO
		set_target_position(velocity)
		return true
	velocity = move_and_slide(velocity)
	return false

func get_target_position():
	return target_position

func set_target_position(pos: Vector2) -> void:
	self.target_position = pos


func get_random_position_from_chunk(chunk_pos):
	var a = Global.map_data[chunk_pos].cells.keys()
	a = a[randi() % a.size()]
	if Global.map_data[chunk_pos].cells[a].walkable:
		# map_position coord
		return a
	else:
		print("PICKING ANOTHER")
		return get_random_position_from_chunk(chunk_pos)
	
	
func _on_ProximityDetector_body_entered(body: Node) -> void:
	if body is StaticBody2D:
		objects_near_me.push_back(body)
		SignalBus.emit_signal("object_entered_proximity", body)
		
		return
	if body != self and body is KinematicBody2D:
		characters_near_me.push_back(body)
		SignalBus.emit_signal("character_entered_proximity", body)


func _on_ProximityDetector_body_exited(body: Node) -> void:
	if body is StaticBody2D:
		var object_index: int = objects_near_me.find(body)
		if object_index >= 0:
			objects_near_me.remove(object_index)
		return
	var character_index: int = characters_near_me.find(body)
	if character_index >= 0:
		characters_near_me.remove(character_index)


func _on_Character_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not targeted:
		if event is InputEventMouseButton && event.is_pressed():
			var stat_screen: Control = preload("res://ui/CharacterMenu.tscn").instance()
			stat_screen.personality_data = data.personality
			SignalBus.emit_signal("anchor_detected", {"global_position": self, "zoom_level": 0.5, "ui": stat_screen})
			targeted = true
			$Sprite2/AnimatedSprite.play(data.personality.emotion_controller.primary_emotion.title.to_lower())
			$Sprite2.visible = true
	if event is InputEventMouseButton && event.is_pressed():
		print(true)


func _input(event: InputEvent) -> void:
	if targeted:
		if event is InputEventKey and event.is_pressed():
			if event.get_scancode() == KEY_ESCAPE:
				SignalBus.emit_signal("anchor_detached")
				$Sprite2/AnimatedSprite.stop()
				$Sprite2.visible = false
				targeted = false
