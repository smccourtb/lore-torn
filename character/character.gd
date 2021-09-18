extends Resource
class_name Character

# Need to provide race_data (character_template.gd)
var race_data: Resource

var race: String
var gender: String
var age: int
var name: String
var height: int # might rename to current height
var weight: int
var eye_color_gene: Gene
var height_gene: Gene
var max_possible_height: int #inches
var personality: Resource
var mood_level: Dictionary

func _init() -> void:
	print("Character called")
	
	

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
	#TODO: add a check if there is a description OR just add a neutral description to facets.
	return ("""Here is a %s %s! %s goes by the name of %s. 
	%s is %s'%s tall, weighs %slbs, and %s is %s years old.
	%s eyes are the color %s. %s %s and %s %s. %s wants to %s. %s %s."""
		% [self.gender, self.race, determine_pronoun().subject.capitalize(), self.name, 
		determine_pronoun().subject.capitalize(), floor(float(self.height) / 12), self.height % 12, 
		self.weight, determine_pronoun().subject, self.age, determine_pronoun().possesive.capitalize(),
		self.eye_color_gene.get_phenotype(), determine_pronoun().subject.capitalize(), self.personality.facets.humor.description,
		determine_pronoun().subject.capitalize(), self.personality.facets.vanity.description, determine_pronoun().subject.capitalize(), 
		self.personality.goals["Goals"], determine_pronoun().subject.capitalize(), self.personality.beliefs.family.description])

func determine_pronoun():
	if self.gender == "male":
		return {"subject": "he", 
				"possesive": "his",
				"object": "him"}
	elif self.gender == "female":
		return {"subject": "she", 
				"possesive": "her",
				"object": "her"}

func tell_a_joke():
	if personality.facets.humor.value > 50:
		print('IT IS AND THIS WORKS')

func have_conversation():
	pass