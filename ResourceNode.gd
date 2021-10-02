extends StaticBody2D


var texture: AtlasTexture
var data: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = texture
	name = data.type

func get_object_type():
	return data.type

func action(character):
	print('THIS TREE HAS BEEN CUT')
	Global.resource_nodes.erase(self)
	queue_free()
	return true
