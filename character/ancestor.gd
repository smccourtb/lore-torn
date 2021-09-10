extends Character
class_name Ancestor


var race_data: Resource

func _init(data: Resource):
	assert(data, "Need to provide race_data.")
	race_data = data
	self.race = determine_race()
	self.gender = determine_gender()
	self.name = determine_name()
	self.age = determine_age()
	self.weight = determine_weight()
	self.height = determine_height()
	self.eye_color = determine_eye_color()
	
func determine_gender():
	if race_data.genders:
		return Util.choose(['male', 'female'])

func determine_race() -> String:
	return race_data.race

func determine_name() -> String:
	# Get gender-specific first_name list
	var full_name: String
	if self.gender:
		var gendered_first_name = race_data.names.get(self.gender + '_first_names')
		full_name = Util.choose(gendered_first_name)
	else:
		var names = [race_data.names.male_first_names + race_data.names.female_first_names]
		self.name = Util.choose(names)
	if race_data.names.last_names.size() > 0:
		var last_name = Util.choose(race_data.names.last_names)
		full_name += " " + last_name
	return full_name

func determine_age() -> int:
	# TODO: add a check for immortality
	# TODO: add a way to specify baby, child, adult, elderly
	var max_age = race_data.lifespan.max()
	return Util.randi_range(race_data.adult_age, max_age)

func determine_weight() -> int:
	return Util.randi_range(race_data.weight_range.min(), race_data.weight_range.max())

func determine_height() -> int:
	return Util.randi_range(race_data.height_range.min(), race_data.height_range.max())

func determine_eye_color() -> Gene:
	var eyco = GeneFactory.new(race_data.eye_color_alleles)
	var gene = eyco.generate_gene()
	return gene


