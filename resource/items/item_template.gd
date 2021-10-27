extends Resource
class_name ItemTemplate

export var texture: AtlasTexture
export var name: String
export var type: String
export var subtype: String

func get_texture() -> AtlasTexture:
	return self.texture

func get_name() -> String:
	return self.name

func get_type() -> String:
	return self.type

func get_subtype() -> String:
	return self.subtype


