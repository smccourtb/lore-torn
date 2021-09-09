extends Resource
class_name Character

# These variables are either filled in prior to setup using the editor,
# or set using the init function from another script. The variables themselves
# are used for the various functions in this script to build the character and 
# then the output of thsoe functions get set to the group of variables below
# to be accessed and read/modified.

export var _possible_name : Resource

export var _possible_gender: bool

export var _possible_lifespan: Array

export var _adult_age : int

export var _possible_weight: Array

export var _possible_height: Array

export var _race: String

# These are the de facto variables to access. They ARE the character.

var race : String
var name : String
var gender: String
var age: int
var height: int
var weight: int
var eye_color
 
# # # # # # # # # # # # # # #
#var iris_color: Gene
#var iris_pigment : Gene

func _init(npc_data):
	print("npc_generator.gd called from init")
	_setup_variables(npc_data)
	generate()
	

func _ready() -> void:
	print("npc_generator.gd called from ready")
	randomize()
	generate()


func _setup_variables(template_data) -> void:
#	TODO: Add check to see if each variable exists and add exception or default value
	_possible_gender = template_data.genders
	_possible_name = template_data.names
	_possible_lifespan = template_data.lifespan
	_adult_age = template_data.adult_age
	_possible_height = template_data.height_range
	_possible_weight = template_data.weight_range
	_race = template_data.race


func generate() -> void:
	race = generate_race()
	gender = generate_gender()
	name = generate_character_name()
	age = generate_age()
	weight = generate_weight()
	height = generate_height()
	eye_color = determine_eye_color()
#	print('PHENOTYPE: ', determine_genotype())
#	TODO: need a way to generate professions and skill levels


func generate_gender():
	if _possible_gender:
		return Util.choose(['male', 'female'])


func generate_character_name() -> String:
	# Get gender-specific first_name list
	var full_name: String
	if gender:
		var gendered_first_name = _possible_name.get(gender + '_first_names')
		full_name = Util.choose(gendered_first_name)
	else:
		var names = [_possible_name.male_first_names + _possible_name.female_first_names]
		name = Util.choose(names)
	if _possible_name.last_names.size() > 0:
		var last_name = Util.choose(_possible_name.last_names)
		full_name += " " + last_name
	return full_name


func generate_age() -> int:
	# TODO: add a check for immortality
	# TODO: add a way to specify baby, child, adult, elderly
	var max_age = _possible_lifespan.max()
	return Util.randi_range(_adult_age, max_age)


func generate_weight() -> int:
	return Util.randi_range(_possible_weight.min(), _possible_weight.max())


func generate_height() -> int:
	return Util.randi_range(_possible_height.min(), _possible_height.max())
	

func generate_race() -> String:
	return _race
	
func determine_eye_color():
	var possible_alleles = [load("res://character/traits/eyes/alleles/blue_eyes.tres"),
						load("res://character/traits/eyes/alleles/brown_eyes.tres"),
						load("res://character/traits/eyes/alleles/green_eyes.tres")]
	var EYCO = GeneFactory.new(possible_alleles)
	var x = EYCO.generate_gene()
	print("EYE COLOR GENE: ", x.phenotype)
