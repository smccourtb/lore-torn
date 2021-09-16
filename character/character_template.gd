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
export var height_alleles: Array

# Name Group
export var names : Resource

# Personality Traits
export var vanity: Array = [0,50,100] # min, average, max
export var modesty: Array = [0,50,100]