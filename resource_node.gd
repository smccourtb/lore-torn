extends StaticBody2D
class_name ResourceNode

# IDEA: If tree or whatever is especially big or special in someway then note it in the history or memorie
var data: Resource
var selected: bool = false setget set_selected
var type: String
var subtype: String
var resource_node_name: String
var drops: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_node(data)

func setup_node(resource_node_data):
	$Sprite.texture = resource_node_data.texture
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
	Global.resource_nodes.erase(self)
	SignalBus.emit_signal("resource_removed", self, get_object_type())
	character.data.energy_level -= 1 # just testing #TODO: decrease by (size of tree, strength, skill)
	drop_items()
	queue_free()
	return true
	
func set_selected(boo: bool):
	selected = boo
	var selector = load("res://Selector.tscn").instance()
	add_child(selector)
	if Global.resource_nodes.find(self) == -1:
		Global.resource_nodes.append(self)

func drop_items():
	# TODO: Add a more elegant way of deciding what to drop and how much
	var at = position
	var count = 1
	var spacing = 2 * PI / count
	for i in count:
		var item = load("res://Item.tscn").instance()
		var x = Util.choose(drops)
		item.title = x.name
		get_parent().add_child(item)
		item.sprite.texture = x.texture
		# Offset the angle based on the iteration
		var angle = spacing * i
		# add a bit of randomization to scatter it about
		angle += rand_range(0, spacing) - spacing * 0.5
		item.spawn(at, angle)

func determine_time_to_harvest():
	# Size of tree
	# Skill of character
	# Strength of character
	# Energy level of character
	# Quality/Components of axe (maybe if not using an axe a negative modifier)
	
	pass
