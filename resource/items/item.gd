extends KinematicBody2D
class_name Item

onready var sprite = $Sprite
# Timer to delay pickup to allow them a moment to spawn and the player to see them
var data: Resource
var type: String
var subtype: String
var id: int
var forbidden: bool
var selected: bool = false

func _ready():
	setup_node(data)
	id = get_instance_id()
	
func setup_node(item_data) -> void:
	$Sprite.texture = item_data.texture
	type = item_data.type
	subtype = item_data.subtype
	data = null

func get_object_type():
	return type

func get_object_subtype():
	return subtype
# warning-ignore:unused_argument
func spawn(at : Vector2):
	global_position = at
	var grid_coord = Global.map_grid.calculate_grid_coordinates(position)
	Global.items[grid_coord] = id

func get_class():
	return "Item"
