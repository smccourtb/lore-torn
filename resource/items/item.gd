extends KinematicBody2D
class_name Item

onready var sprite = $Sprite
# Timer to delay pickup to allow them a moment to spawn and the player to see them
var data: Resource
var type: String
var subtype: String

func _ready():
	setup_node(data)
	
func setup_node(item_data) -> void:
	$Sprite.texture = item_data.texture
	type = item_data.type
	subtype = item_data.subtype
	data = null
	
func _on_pickup():
	queue_free()

func get_object_type():
	return type

# warning-ignore:unused_argument
func spawn(at : Vector2):
	global_position = at
	if Global.items.has(data.type):
		Global.items[data.type].append(self)
	else:
		Global.items[data.type] = [self]
