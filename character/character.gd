extends Resource
class_name Character

# These variables are either filled in prior to setup using the editor,
# or set using the init function from another script. The variables themselves
# are used for the various functions in this script to build the character and 
# then the output of thsoe functions get set to the group of variables below
# to be accessed and read/modified.


# These are the de facto variables to access. They ARE the character.

var race: String
var gender: String
var age: int
var name: String
var height: int
var weight: int
var eye_color: Gene

func character_data() -> Array:
	var a = {"race": self.race, 
			"age": self.age, 
			"name": self.name,
			"gender": self.gender, 
			"height": self.height, 
			"weight": self.weight,
			"eye_color": self.eye_color
			}
	var b = get_property_list()
	return [a,b]

func determine_race():
	pass
	
func determine_gender():
	pass

func determine_name():
	pass

func determine_age():
	pass

func determine_weight():
	pass

func determine_height():
	pass
	
func determine_eye_color():
	pass

func get_description() -> String:
	return ("""This is a %s %s that goes by the name of %s. 
	They are %s' tall and weigh %s lbs. They are %s years old.
	Their eyes are the color %s."""
		% [self.gender, self.race, self.name, stepify(self.height/12, 0.1), 
		self.weight, self.age, self.eye_color.get_phenotype()])

func determine_pronoun():
	if gender == "male":
		return {"subject": "he", 
				"possesive": "his",
				"object": "him"}
	elif gender == "female":
		return {"subject": "she", 
				"possesive": "hers",
				"object": "her"}




