extends Resource
class_name Character_Template

# This resource is used as the framework to build a character.
# A semi-procedural character based on the given data here.
# Build-a character
# OR
# Bare bones of what could be based on race
# This isnt actually building a character. This is the general base to start with
export var race: String
export var genders: bool  # false: no gender // true: males & females
export var lifespan: = []
export var adult_age: int
export var weight_range = []
export var height_range = []
## PHYSICAL TRAITS ## 
export var eye_color = {}

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
