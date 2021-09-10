extends Node2D

var character_data
var DWARF : = "res://character/dwarf.tres"
#onready var eye_color = preload("res://character/traits/eye_color.tres")
var npc_choices: Array = [DWARF]

# Eye gene test variables
var eye_genes = []

func generate_ancestor(gender=null) -> Ancestor:
	npc_choices.shuffle()
	var character = Ancestor.new(load(npc_choices[0]), gender)
	name = character.name
	return character

func generate_descendant() -> Descendant:
	var mother = generate_ancestor("female")
	print("Mother: ", mother.get_description())
	var father = generate_ancestor("male")
	print("Father: ", father.get_description())
	var character = Descendant.new({"mother": mother,"father": father})
	print("Child: ", character.get_description())
	name = character.name
	return character

func _ready():
	randomize()
	var a = OS.get_ticks_msec()
#	for i in range(10000):
	character_data = generate_descendant()
	var b = OS.get_ticks_msec()
#	print("Generated 30,000 characters in " + str((b - a)/1000.00) + " seconds")
