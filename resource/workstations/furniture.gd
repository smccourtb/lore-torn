extends Construction
class_name Furniture



func setup_node(resource_data: FurnitureTemplate) -> void:
	($Sprite as Sprite).set_texture(resource_data.get_texture())
	id = get_instance_id()
