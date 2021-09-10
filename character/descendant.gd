extends Character
class_name Descendant

var mother_data
var father_data



func _init(parent_data: Dictionary):
	assert(parent_data, "Need to provide parent_data.")
	mother_data = parent_data.mother
	father_data = parent_data.father
	check_compatibility()
	self.race = determine_race()
	self.gender = determine_gender()
	self.name = determine_name()
	self.age = determine_age()
	self.weight = determine_weight()
	self.height = determine_height()
	self.eye_color = determine_eye_color()

func determine_race():
	return father_data.race
	
func determine_gender() -> String:
	var mother = ["X", "X"]
	var father = ["X", "Y"]
	var result = Util.choose(mother) + Util.choose(father)
	if result == "XY":
		return "male"
	return "female"

func determine_name():
	# This seems a little flimsy. I'd like a better way to access race_data for the names
	var full_name: String
	if self.gender:
		var gendered_first_name = father_data.race_data.names.get(self.gender + '_first_names')
		full_name = Util.choose(gendered_first_name)
	else:
		var names = [father_data.race_data.names.male_first_names + father_data.race_data.names.female_first_names]
		self.name = Util.choose(names)
	if father_data.name.split("").size() > 1:
		var paternal_name = father_data.name.split("")
		var last_name = paternal_name[1]
		full_name += " " + last_name
	return full_name

func determine_age():
	# my line of thinking is that they are just born right?
	return 0

# Wtth these 2 functions maybe it would be better left as a calculation based on age, race, 
# and genes so it can be called and updated when needed as it will change over time
func determine_weight():
	return 8

func determine_height():
	return 12
	
func determine_eye_color():
	return punnet_square(mother_data.eye_color, father_data.eye_color)

func punnet_square(mother: Gene, father: Gene):
	var A = mother.genotype[0]
	var B = mother.genotype[1]
	var X = father.genotype[0]
	var Y = father.genotype[0]
	var punnett = [[A,X],[A,Y],[B,X],[B,Y]]
	var result = Util.choose(punnett)
	var descendant_gene = Gene.new(result[0], result[1])
	return descendant_gene

func check_compatibility():
	assert(father_data.race == mother_data.race, "Parents are not compatible, they cannot procreate.")
