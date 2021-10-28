extends Resource
class_name ConstructionTemplate


export var name: String
export var texture: AtlasTexture
export var materials: Dictionary

func get_name() -> String:
	return name

func get_texture() -> AtlasTexture:
	return texture
