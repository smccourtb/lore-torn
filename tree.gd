extends ResourceNode
class_name TreeNode


func _init(data: Resource) -> void:
	.set_node_data(data)
	type = node_data.type
	subtype = node_data.subtype
	texture = node_data.texture
