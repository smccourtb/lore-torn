extends Resource
class_name Personality

const openness = "openness"
const concientiousness = "conscientiousness"
const extraversion = "extroversion"
const agreeableness = "agreeableness"
const neuroticism = "neuroticism"

const TRAIT_STRINGS = [openness, concientiousness, extraversion, agreeableness, neuroticism]
var traits: Dictionary

func _init() -> void:
	generate_personality()

func generate_personality():
	for i in TRAIT_STRINGS:
		traits[i] = PersonalityTrait.new(load("res://character/personality/" + i + ".tres"))


func get_trait_score(trait_name:String) -> int:
	return traits[trait_name].get_total_value()

func get_total_score() -> int:
	var total: int = 0
	for i in TRAIT_STRINGS:
		total += get_trait_score(i)
	return total
