extends Resource
class_name Prop

var type: String
var subtype: String
var name: String
var texture: AtlasTexture

func _init(data: Resource) -> void:
	self.type = data.type
	self.subtype = data.subtype
	self.name = data.name
	self.texture = texture
