extends Character
class_name Ancestor


func _init(data: Resource, gender=null) -> void:
	assert(data, "Need to provide race_data.")
	self.race_data = data
	self.race = determine_race()
	self.gender = determine_gender(gender)
	self.name = determine_name()
	self.age = determine_age()
	self.weight = determine_weight()
	self.height_gene = determine_height_gene()
	self.max_possible_height = determine_max_possible_height()
	self.height = determine_height()
	self.eye_color_gene = determine_eye_color_gene()
	self.personality = Personality.new()

func determine_gender(gender=null):
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
	if self.age < 16:
	# FIXME : make this more of a curve instead of linear
		var growth_modifier = float(self.max_possible_height) / 16
		
		var current_height = (self.age * growth_modifier)
		# TODO: add nutrition to this when implemented
		return current_height
	return self.max_possible_height

func determine_eye_color_gene() -> Gene:
	var eyco = GeneFactory.new(self.race_data.eye_color_alleles)
	var gene = eyco.generate_gene()
	return gene

func determine_height_gene() -> Gene:
	var heig = GeneFactory.new(self.race_data.height_alleles)
	var gene = heig.generate_gene()
	return gene

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
		


