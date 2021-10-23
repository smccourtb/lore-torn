extends Resource
class_name WorkstationTemplate

export var name: String
export var texture: AtlasTexture
export var project_options: Array
export var materials: Dictionary

func get_name() -> String:
	return name

func get_texture() -> AtlasTexture:
	return texture
