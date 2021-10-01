class_name ResourceNode
extends Resource

var node_data: Resource
# static texture representation when added to scene tree
var texture: AtlasTexture
# tree, rock, plant
var type: String
# if tree: oak, willow, birch, etc | if rock: stone, tin, gold  etc.
var subtype: String

func _init() -> void:
	print("STill BEINg CalLLEd")
	
	

func get_type() -> String:
	return type

func set_type() -> void:
	pass
	
func set_node_data(data: Resource) -> void:
	self.node_data = data
	
	
#func setup_node(var _bloom):
#	hits = node_resource.hits
#
#	drops = node_resource.drops

