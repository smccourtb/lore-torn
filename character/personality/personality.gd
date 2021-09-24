extends Resource
class_name Personality

const openness = "openness"
const concientiousness = "conscientiousness"
const extraversion = "extroversion"
const agreeableness = "agreeableness"
const nueroticism = "neuroticism"

const TRAIT_STRINGS = [openness, concientiousness, extraversion, agreeableness, nueroticism]
var traits: Dictionary

func _init() -> void:
	generate_personality()
	# print(str(nueroticism.get_total_value()) + "/600")
	# print(traits.neuroticism.facets.anxiety.get_current_value())

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