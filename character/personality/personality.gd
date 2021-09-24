extends Resource
class_name Personality
# I will be restructing this following the OCEAN Model.
var nueroticism = "neuroticism"
# Concientiousness = PersonalityTrait.new()
# Extraversion = PersonalityTrait.new()
# Agreeableness = PersonalityTrait.new()
# openness = PersonalityTrait.new()
const TRAIT_STRINGS = ["neuroticism"]
var traits: Dictionary

func _init() -> void:
	generate_personality()
	# print(str(nueroticism.get_total_value()) + "/600")
	print(traits.neuroticism.facets.anxiety.get_current_value())

func generate_personality():
	for i in TRAIT_STRINGS:
		traits[i] = PersonalityTrait.new(load("res://character/personality/" + i + ".tres"))
