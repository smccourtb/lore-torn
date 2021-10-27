extends KinematicBody2D
class_name Item

# Timer to delay pickup to allow them a moment to spawn and the player to see them
var type: String
var subtype: String
var id: int
#var forbidden: bool
var selected: bool = false

func _ready():
	self.id = get_instance_id()
	
func setup_node(data: ItemTemplate) -> void:
	($Sprite as Sprite).set_texture(data.get_texture())
	type = data.get_type()
	subtype = data.get_subtype()

func get_object_type():
	return self.type

func get_object_subtype():
	return self.subtype

func spawn(at : Vector2):
	self.global_position = at
	var grid_coord: Vector2 = Global.map_grid.calculate_grid_coordinates(position)
	Global.items[grid_coord] = id

func get_class():
	return "Item"

func get_id() -> int:
	return self.id

func get_selected() -> bool:
	return self.selected

func set_selected(to: bool):
	self.selected = to
