extends Character
class_name Ancestor


func _init(data: Resource, gender=null) -> void:
	print("Generating Ancestor")
	assert(data, "Need to provide race_data.")
	.set_race_data(data)
	.set_race(determine_race())
	.set_gender(determine_gender(gender))
	.set_name(determine_name())
	.set_age(determine_age())
	determine_genes()
	.set_weight(determine_weight())
	.set_height(determine_height())	
	print("Done Generating Ancestor")

func determine_gender(gender=null):
	# Not in love with this implementation
	# What about 1 gender or more than 2
	# TODO: change race data genders from a bool value to list of strings ("male", "female")
	if gender:
		return gender
	elif self.race_data.genders:
		return Util.choose(['male', 'female'])

func determine_race() -> String:
	return self.race_data.race

func determine_name() -> String:
	# Get gender-specific first_name list
	var full_name: String
	if self.gender:
		var gendered_first_name = self.race_data.names.get(self.gender + '_first_names')
		full_name = Util.choose(gendered_first_name)
	else:
		var names = [self.race_data.names.male_first_names + self.race_data.names.female_first_names]
		self.name = Util.choose(names)
	if self.race_data.names.last_names.size() > 0:
		var last_name = Util.choose(self.race_data.names.last_names)
		full_name += " " + last_name
	return full_name

func determine_age() -> int:
	# TODO: add a check for immortality
	# TODO: add a way to specify baby, child, adult, elderly
	var max_age = self.race_data.lifespan.max()
	return Util.randi_range(self.race_data.adult_age, max_age)

func determine_weight() -> int:
	return Util.randi_range(self.race_data.weight_range.min(), self.race_data.weight_range.max())

func determine_height() -> int:
	var max_possible_height = .determine_max_possible_height()
	if self.age < 16:
	# FIXME : make this more of a curve instead of linear
		var growth_modifier = float(max_possible_height) / 16
		
		var current_height = (self.age * growth_modifier)
		# TODO: add nutrition to this when implemented
		.set_height(current_height)
	return max_possible_height

func determine_eye_color_gene() -> Gene:
	var eyco = GeneFactory.new(self.race_data.eye_color_alleles)
	var gene = eyco.generate_gene()
	return gene

func determine_height_gene() -> Gene:
	var heig = GeneFactory.new(self.race_data.height_alleles)
	var gene = heig.generate_gene()
	return gene

func determine_genes() -> void:
	self.genes['eyecolor'] = determine_eye_color_gene()
	self.genes['height'] = determine_height_gene()
	


