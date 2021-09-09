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


func punnet_square(mother, father):
	var A = mother.genotype[0]
	var B = mother.genotype[1]
	var X = father.genotype[0]
	var Y = father.genotype[0]
	var punnett = [[A,X],[A,Y],[B,X],[B,Y]]
	return Util.choose(punnett)



