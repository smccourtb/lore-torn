extends Character
class_name Descendant

var mother_data
var father_data

func _init(parent_data: Dictionary):
	assert(parent_data, "Need to provide parent_data.")
	mother_data = parent_data.mother
	father_data = parent_data.father
	self.race_data = father_data.race_data
	check_compatibility()
	self.race = determine_race()
	self.gender = determine_gender()
	self.name = determine_name()
	self.age = determine_age()
	self.weight = determine_weight()
	self.height_gene = determine_height_gene()
	self.max_possible_height = determine_max_possible_height()
	
	self.height = determine_height()
	self.eye_color_gene = determine_eye_color_gene()

func determine_race():
	# we just need to pull from one parent, doesn't matter which. cross breeding not implemented.
	return father_data.race
	
func determine_gender() -> String:
	var mother = ["X", "X"]
	var father = ["X", "Y"]
	var result = Util.choose(mother) + Util.choose(father)
	if result == "XY":
		return "male"
	return "female"

func determine_name() -> String:
	# This seems a little flimsy. I'd like a better way to access race_data for the names
	var full_name: String
	if self.gender:
		var gendered_first_name = father_data.race_data.names.get(self.gender + '_first_names')
		full_name = Util.choose(gendered_first_name)
	else:
		var names = [father_data.race_data.names.male_first_names + father_data.race_data.names.female_first_names]
		self.name = Util.choose(names)
#	check for last name
	if father_data.name.split(" ").size() > 1:
		var last_name = father_data.name.split(" ")[1]
		full_name += " " + last_name
	return full_name

func determine_age() -> int:
	# my line of thinking is that they are just born right?
	return 0

# Wtth these 2 functions maybe it would be better left as a calculation based on age, race, 
# and genes so it can be called and updated when needed as it will change over time
func determine_weight() -> int:
	return 8

func determine_height() -> int:
	if self.age < 16:
	# FIXME : make this more of a curve instead of linear
		var growth_modifier = float(self.max_possible_height) / 16
		var current_age: int = self.age
		if current_age == 0:
			current_age = 1
		var current_height = 12 + (current_age * growth_modifier)
		# TODO: add nutrition to this when implemented
		return current_height
	return self.max_possible_height
	
func determine_eye_color_gene() -> Gene:
	return punnet_square(mother_data.eye_color_gene, father_data.eye_color_gene)

func punnet_square(mother: Gene, father: Gene) -> Gene:
	var A = mother.genotype[0]
	var B = mother.genotype[1]
	var X = father.genotype[0]
	var Y = father.genotype[0]
	var punnett = [[A,X],[A,Y],[B,X],[B,Y]]
	var result = Util.choose(punnett)
	var descendant_gene = Gene.new(result[0], result[1])
	return descendant_gene

func check_compatibility() -> bool:
#	check for matching race
	assert(father_data.race == mother_data.race, "Parents are not compatible, they cannot procreate.")
#	check for opposite sex
	assert(father_data.gender == "male" && mother_data.gender == "female", "Parents are same sex, they cannot procreate.")
#	check for birth age
	assert(mother_data.age >= 16, "One or more of the parent(s) are too young to concieve")
	return true

func determine_height_gene():
	return punnet_square(mother_data.height_gene, father_data.height_gene)


func determine_max_possible_height() -> int:
	var count: int = 0
	var race_height_diff = self.race_data.max_height - self.race_data.min_height
	for i in self.height_gene.genotype:
		count += i.dominant
	if count > 1:
		var min_height = self.race_data.max_height - round(race_height_diff * .25) 
		return Util.choose([min_height, self.race_data.max_height])
	elif count > 0:
		var min_height = self.race_data.max_height - round(race_height_diff * .50)
		return Util.choose([min_height, self.race_data.max_height])
	return Util.choose([self.race_data.min_height, round(self.race_data.min_height + (self.race_data.min_height *.50))])
		

