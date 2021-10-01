class_name ResourceNode
extends Resource

var texture: AtlasTexture
var type: String
var subtype: String
var can_cut = true

func _init(resource_data: Resource) -> void:
	print("STill BEINg CalLLEd")
	type = resource_data.type
	subtype = resource_data.subtype
	texture = resource_data.texture
	

func get_object_type():
	if can_cut:
		return type
	else:
		return "tree_not_ready"
		


#func setup_node(var _bloom):
#	hits = node_resource.hits
#
#	drops = node_resource.drops

