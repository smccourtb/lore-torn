extends Node2D

var character_data
var DWARF : = "res://character/dwarf.tres"

var npc_choices: Array = [DWARF]


func _ready():
	character_data = generate_descendant()
	print(character_data.personality)
# 	print("CharacterGenerator is ready")
# 	randomize()
# 	var a = OS.get_ticks_msec()
# #	for i in range(10000):
# 	character_data = generate_descendant()
# 	var b = OS.get_ticks_msec()
#	print("Generated 30,000 characters in " + str((b - a)/1000.00) + " seconds")
	# test_breeding()
func generate_ancestor(gender=null) -> Ancestor:
	npc_choices.shuffle()
	var character = Ancestor.new(load(npc_choices[0]), gender)
	# name = character.name
	return character

func generate_descendant() -> Descendant:
	var mother = generate_ancestor("female")
	var father = generate_ancestor("male")
	var child: Descendant
	if check_compatibility(mother, father):
		child = Descendant.new({"mother": mother,"father": father})
	else:
		generate_descendant()
	return child

func check_compatibility(mother_data, father_data) -> bool:
	#	check for matching race
		assert(father_data.race == mother_data.race, "Parents are not compatible, they cannot procreate.")
	#	check for opposite sex
		assert(father_data.gender == "male" && mother_data.gender == "female", "Parents are same sex, they cannot procreate.")
	#	check for birth age
		assert(mother_data.age >= 16, "One or more of the parent(s) are too young to concieve")
		return true
