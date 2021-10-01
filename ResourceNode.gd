extends StaticBody2D


var texture: AtlasTexture
var data: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.texture = texture
	name = data.type


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
