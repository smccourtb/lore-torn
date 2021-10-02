extends StaticBody2D

# IDEA: If tree or whatever is especially big or special in someway then note it in the history or memories
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
	SignalBus.emit_signal("resource_removed", self, get_object_type())
	# TODO: add signal that alerts this node has been removed
	# then connect to character controller to acquire new target
	character.data.energy_level -= 1 # just testing #TODO: decrease by (size of tree, strength, skill)
	spawn_resources()
	queue_free()
	return true
	
func set_selected(boo: bool):
	selected = boo
	var selector = load("res://Selector.tscn").instance()
	add_child(selector)
	if Global.resource_nodes.find(self) == -1:
		Global.resource_nodes.append(self)
#	get_parent().resource_node_positions.append(global_position)

func spawn_resources():
	# TODO: Add a more elegant way of deciding what to drop and how much
	var at = position
	var count = 2
	var spacing = 2 * PI / count
	for i in count:
		var item = load("res://Collectable.tscn").instance()
		var x = Util.choose(data.node_data.drops)
		item.title = x.name
		print(x.name)
		get_parent().add_child(item)
		item.sprite.texture = x.texture
		# Offset the angle based on the iteration
		var angle = spacing * i
		# add a bit of randomization to scatter it about
		angle += rand_range(0, spacing) - spacing * 0.5
		item.spawn(at, angle)
		
		#item.sprite.region_rect = x.texture_region
