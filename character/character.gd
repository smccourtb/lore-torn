extends Resource
class_name Character

# These variables are either filled in prior to setup using the editor,
# or set using the init function from another script. The variables themselves
# are used for the various functions in this script to build the character and 
# then the output of thsoe functions get set to the group of variables below
# to be accessed and read/modified.

var race_data: Resource
# These are the de facto variables to access. They ARE the character.

var race: String
var gender: String
var age: int
var name: String
var height: int # might rename to current height
var weight: int
var eye_color_gene: Gene
var height_gene: Gene
var max_possible_height: int #inches

var personality: Dictionary
	
func character_data() -> Dictionary:
	return {"race": self.race, 
			"age": self.age, 
			"name": self.name,
			"gender": self.gender, 
			"height": self.height, 
			"weight": self.weight,
			"eye_color": self.eye_color_gene.get_phenotype()
			}

func get_description() -> String:
	return ("""Here is a %s %s! %s goes by the name of %s. 
	%s is %s'%s tall, weighs %slbs, and %s is %s years old.
	%s eyes are the color %s."""
		% [self.gender, self.race, determine_pronoun().subject.capitalize(), self.name, 
		determine_pronoun().subject.capitalize(), floor(float(self.height) / 12), self.height % 12, 
		self.weight, determine_pronoun().subject, self.age, determine_pronoun().possesive.capitalize(),
		self.eye_color_gene.get_phenotype()])

func determine_pronoun():
	if self.gender == "male":
		return {"subject": "he", 
				"possesive": "his",
				"object": "him"}
	elif self.gender == "female":
		return {"subject": "she", 
				"possesive": "her",
				"object": "her"}

func determine_personality():
	var traits = determine_personality_traits()
	self.personality["traits"] = traits

func determine_personality_traits():
	var traits: = {}
	var traits_list: Array = ['vanity']
	for i in traits_list:
		var x = load("res://" + i + ".tres")
		var t = Trait.new(x)
		# TODO: Change to weighted value pick
		var value = Util.randi_range(1,100)
		traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
	return traits
