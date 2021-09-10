extends Node2D

var character_data
var DWARF : = "res://character/dwarf.tres"
#onready var eye_color = preload("res://character/traits/eye_color.tres")
var npc_choices: Array = [DWARF]

# Eye gene test variables
var eye_genes = []

func generate_ancestor() -> Character:
	npc_choices.shuffle()
	var character = Ancestor.new(load(npc_choices[0]))
	name = character.name
	return character

func generate_descendant() -> Character:
	var mother = generate_ancestor()
	print(mother.get_description())
	
	var father = generate_ancestor()
	print(father.get_description())
	var character = Descendant.new({"mother": mother,"father": father})
	name = character.name
	return character


func _ready():
	randomize()
	character_data = generate_descendant()
	print(character_data.get_description())
