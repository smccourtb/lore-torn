extends Resource
class_name CharacterTemplate

# This resource is used as the framework to build a character.
# Bare bones of what a character could be based on race
# This isnt actually building a character. This is the general base to start with

# USED TO BUILD A CHARACTER WITH NO ANCESTORS

# constants about the race 
export var race: String
export var genders: bool  # false: no gender // true: males & females
export var lifespan: = []
export var adult_age: int
export var weight_range = []
export var max_weight: int
export var min_weight: int
export var height_range = []
export var max_height: int
export var min_height: int

## PHYSICAL TRAITS ## 
# store all possible alleles in here?
# then just have a bunch of these?
export var eye_color_alleles: Array
export var hair_color_alleles: Array
export var hair_type_alleles: Array

# Name Group
export var names : Resource



# I want to build DWARVES. -> Load the dwarf.tres file (this one) into character_generator.
# Need to include things like:
# [X] How long do DWARVES live for (lifespan)
# [X] possible names to choose from
# [ ] How much do they weigh? Fat and skinny maybe separate
# [ ] How tall can they get?
# [ ] Color eyes
# [ ] Color hair
# [ ] Hair / Facial hair style
# [ ] Stats on the world scale (ex. 1-10 world scale -> dwarves: 6, dragons: 8, crazy demon god: 10)
#	where would that be placed?
# [ ] Skin Color
# [ ] Flammability?
# [ ] Hunger Rate
# [ ] Thirst Rate
# [ ] Ability to fly
# [ ] Can swim or breathe water?
# [ ] Can it hold items or weapons (opposable thumbs?) --maybe tied/influenced with intelligence
