extends Node2D

var character_data
var DWARF : = "res://character/dwarf.tres"

var npc_choices: Array = [DWARF]
var gen1 = []
# Eye gene test variables
var eye_genes = []

func generate_ancestor(gender=null) -> Ancestor:
	npc_choices.shuffle()
	var character = Ancestor.new(load(npc_choices[0]), gender)
	# name = character.name
	return character

func generate_descendant() -> Descendant:
	var mother = generate_ancestor("female")
	print("Mother: ", mother.get_description())
	var father = generate_ancestor("male")
	print("Father: ", father.get_description())
	var character = Descendant.new({"mother": mother,"father": father})
	print("Child: ", character.get_description())
	# name = character.name
	return character

func _ready():
# 	print("CharacterGenerator is ready")
# 	randomize()
# 	var a = OS.get_ticks_msec()
# #	for i in range(10000):
# 	character_data = generate_descendant()
# 	var b = OS.get_ticks_msec()
#	print("Generated 30,000 characters in " + str((b - a)/1000.00) + " seconds")
	test_breeding()

	
func test_breeding():
	for i in range(50):
		var ancestor = generate_ancestor()
		gen1.append(ancestor)
	
	# Now take 2 dwarfs and check compaitibility
	var a = Util.choose(gen1)
	var b = Util.choose(gen1)
	var x = a.determine_compatibility(b.personality)
	var y = b.determine_compatibility(a.personality)
	print("CHARACTER1: ", x)
	print("CHARACTER2: ", y)
		

# Generate a bunch of ancestors and put them in an array
# Assuming they are in the same room and talking, check compatibility of two random dwarfs.
# Check if they like eachother
# Check if they are compatible to breed
# If no to either save their relationship status and repeat from step 2
# IF Yes, make a descendant and put them in generation 2 array
# Dont remove them but if they have the honest trait and are above a certain compatiblity or have breeded them cancel it

