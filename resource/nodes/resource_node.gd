extends StaticBody2D
class_name ResourceNode

# IDEA: If tree or whatever is especially big or special in someway then note it in the history or memorie
var data: Resource
var selected: bool = false setget set_selected
var type: String
var subtype: String
var resource_node_name: String
var drops: Array
var targeted: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_node(data)

func setup_node(resource_node_data):
	$Sprite.texture = resource_node_data.texture
	$Sprite.offset = resource_node_data.texture_offset
	type = resource_node_data.type
	subtype = resource_node_data.subtype
	resource_node_name = type + "_" + subtype
	drops = resource_node_data.drops
	data = null

func get_object_type() -> String:
	return type
	
func get_object_subtype() -> String:
	return subtype

func get_name() -> String:
	return data.name
	
func action(character):
	
	SignalBus.emit_signal("resource_removed", get_object_type(), position)
	character.data.energy_level -= 1 # just testing #TODO: decrease by (size of tree, strength, skill)
	drop_items()
	queue_free()
	return true
	
func set_selected(boo: bool):
	if !selected:
		selected = boo
		var selector = load("res://ui/Selector.tscn").instance()
		add_child(selector)
		Global.resource_nodes[type][Global.map_grid.calculate_grid_coordinates(position)] = self

func drop_items():
	var item = load("res://resource/items/Item.tscn")
	# TODO: Add a more elegant way of deciding what to drop and how much
	# TODO: check neighboring cells for an empty cell
	var at = position
	# TODO: determine how much drops based of size of node
	var count = 1
	for i in count:
		item = item.instance()
		
		var x = Util.choose(drops)
		item.data = x
		get_parent().add_child(item)
		
		item.spawn(at)

func determine_time_to_harvest():
	# Size of tree
	# Skill of character
	# Strength of character
	# Energy level of character
	# Quality/Components of axe (maybe if not using an axe a negative modifier)
	
	pass
