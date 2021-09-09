extends Node2D

var character_data
var DWARF : = "res://character/dwarf.tres"
#onready var eye_color = preload("res://character/traits/eye_color.tres")
var npc_choices: Array = [DWARF]

# Eye gene test variables
var eye_genes = []

func generate_random_npc() -> Character:
	npc_choices.shuffle()
	var character = Ancestor.new(load(npc_choices[0]))
	name = character.name
	return character


func _ready():
	randomize()
	character_data = generate_random_npc()
	print("This is a %s %s that goes by the name of %s. They are %s' tall and weigh %s lbs. They are %s years old." % [character_data.gender, 
		   character_data.race, character_data.name, stepify(character_data.height/12,0.1), 
		   character_data.weight, character_data.age])
	
#	for i in range(100):
#		eye_genes.append(Trait.new([Gene.new(combos),Gene.new(combos)]))
#
#	print("DOOOOOONNE")
