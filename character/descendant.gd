extends Character
class_name Descendant

# TODO: add parents to relationship dictionary 
# TODO: check population for anyone in family tree
# TODO: Create family tree function (linked list? <-NO ... graph?)

var parent_data: Dictionary

func _init(data: Dictionary):
	assert(data, "Need to provide parent_data.")
	set_parent_data(data)
	.set_race_data(get_parent_data("father").race_data)
	.set_race(determine_race())
	determine_genes()
	.set_gender(determine_gender())
	.set_name(determine_name())
	.set_age(determine_age())
	.set_weight(determine_weight())
	.set_height(determine_height())
	
	
func set_parent_data(new_parent_data: Dictionary) -> void:
	self.parent_data = new_parent_data

func get_parent_data(parent: String = ""):
	# Takes 2 inputs: "mother" or "father"
	if !parent:
		return self.parent_data
	return self.parent_data[parent]

func determine_race() -> String:
	# we just need to pull from one parent, doesn't matter which. cross breeding not implemented.
	return get_parent_data("father").race
	
func determine_gender() -> String:
	var mother = ["X", "X"]
	var father = ["X", "Y"]
	var result = Util.choose(mother) + Util.choose(father)
	if result == "XY" || result == "YX":
		return "male"
	return "female"

func determine_name() -> String:
	var full_name: String
	if self.gender:
		var gendered_first_name = get_parent_data("father").race_data.names.get(self.gender + '_first_names')
		full_name = Util.choose(gendered_first_name)
	else:
		var names = [get_parent_data("father").race_data.names.male_first_names + get_parent_data("father").race_data.names.female_first_names]
		self.name = Util.choose(names)
#	check for last name
	if get_parent_data("father").name.split(" ").size() > 1:
		var last_name = get_parent_data("father").name.split(" ")[1]
		full_name += " " + last_name
	return full_name

func determine_age() -> int:
	# my line of thinking is that they are just born right?
	return 0

# With these 2 functions maybe it would be better left as a calculation based on age, race, 
# and genes so it can be called and updated when needed as it will change over time
func determine_weight() -> int:
	return 8

func determine_height() -> int:
	var max_possible_height = .determine_max_possible_height()
	if self.age < 16:
	# FIXME : make this more of a curve instead of linear
		var growth_modifier = float(max_possible_height) / 16
		var current_age: int = self.age
		if current_age == 0:
			current_age = 1
		var current_height = 12 + (current_age * growth_modifier)
		# TODO: add nutrition to this when implemented
		return current_height
	return .get_height()
	
func punnet_square(mother: Gene, father: Gene) -> Gene:
	var A = mother.genotype[0]
	var B = mother.genotype[1]
	var X = father.genotype[0]
	var Y = father.genotype[1]
	var punnett = [[A,X],[A,Y],[B,X],[B,Y]]
	var result = Util.choose(punnett)
	var descendant_gene = Gene.new(result[0], result[1])
	return descendant_gene

func determine_height_gene() -> Gene:
	return punnet_square(get_parent_data("mother").genes.height, get_parent_data("father").genes.height)

func determine_eye_color_gene() -> Gene:
	return punnet_square(get_parent_data("mother").genes.eyecolor, get_parent_data("father").genes.eyecolor)

func determine_genes() -> void:
	self.genes['eyecolor'] = determine_eye_color_gene()
	self.genes['height'] = determine_height_gene()
