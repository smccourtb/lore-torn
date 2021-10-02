extends StaticBody2D

# IDEA: If tree or whateever is especially big or special in someway then note it in the history or memories
var texture: AtlasTexture
var data: Resource
var selected: bool = false setget set_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = texture
	name = data.type

func get_object_type():
	return data.type

func action(character):
	print('THIS TREE HAS BEEN CUT')
	Global.resource_nodes.erase(self)
	# TODO: add signal that alerts this node has been removed
	# then connect to character controller to acquire new target
	character.data.energy_level -= 1 # just testing #TODO: decrease by (size of tree, strength, skill)
	queue_free()
	return true
	
func set_selected(boo: bool):
	selected = boo
	var selector = load("res://Selector.tscn").instance()
	add_child(selector)
	Global.resource_nodes.append(self)
#	get_parent().resource_node_positions.append(global_position)
