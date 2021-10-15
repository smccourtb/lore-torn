extends StaticBody2D
class_name Workstation


var data: Resource
var projects: Array
var materials: Dictionary
var workstation_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_node(data)

func setup_node(resource_data):
	$Sprite.texture = resource_data.texture
	
func action(character):
	# we need what we want to craft
	# we need the mats for said goal
	# we need to check if those mats are in character inventory
		# OR maybe in its own little inventory that the character deposits
		# would need to check if all mats are available before beginning such a task
	# delete mats
	# return crafted item
	# or put in characters inventory
	# OR check if available stockpile
		# if yes go drop it off there
		# if no then drop it in one of the 9 squares or however many around the workstation
			# if there are none available the area is cluttered and you need to resolve it before htat workstation can be used again.
	pass

func generate_crafting_menu():
	pass

func get_available_projects() -> Array:
	var projects = []
	for i in projects:
		projects.append(i.name)
	return projects

func build():
	$Sprite.set_modulate(Color(1,1,1,1))
