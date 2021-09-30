extends Resource
class_name CharacterGenerator

var DWARF : = "res://character/dwarf.tres"

var npc_choices: Array = [DWARF]


func generate_ancestor(gender=null) -> Ancestor:
	npc_choices.shuffle()
	var character = Ancestor.new(load(npc_choices[0]), gender)
	# name = character.name
	return character

 # Is not used for breeding. More of a test and quick I need a descendant option.
func generate_descendant() -> Descendant:
	var mother = generate_ancestor("female")
	var father = generate_ancestor("male")
	var child: Descendant
	if check_compatibility(mother, father):
		child = Descendant.new({"mother": mother,"father": father})
	return child

func generate_new_tribe():
	pass


func check_compatibility(mother_data, father_data) -> bool:
	# TODO: add min and max birthing age to race_data template and replace the 16 with that variable.
	#	check for matching race
		assert(father_data.race == mother_data.race, "Parents are not compatible, they cannot procreate.")
	#	check for opposite sex
		assert(father_data.gender == "male" && mother_data.gender == "female", "Parents are same sex, they cannot procreate.")
	#	check for birth age
		assert(mother_data.age >= 16, "The mother is too young to concieve")
	# max(10,min(age_1,age_2)/2) <- age difference
		return true
