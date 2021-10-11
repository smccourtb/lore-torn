extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
