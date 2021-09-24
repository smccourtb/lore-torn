extends Resource
class_name Personality
# I will be restructing this following the OCEAN Model.
var openness = PersonalityTrait.new(load("res://character/personality/neuroticism.tres"))
# Concientiousness = PersonalityTrait.new()
# Extraversion = PersonalityTrait.new()
# Agreeableness = PersonalityTrait.new()
# Nueroticism = PersonalityTrait.new()

var facets: Dictionary
var beliefs: Dictionary
var goals: Dictionary

func _init() -> void:
	print(str(openness.get_total_value()) + "/600")
	print(openness.facets.anxiety.get_current_value())
	# facets = determine_traits()
	# beliefs = determine_beliefs()
	# goals = determine_goals()

# func determine_traits() -> Dictionary:
# 	var _traits: = {}
# 	var traits_list: Array = ['vanity', 'humor']
# 	for i in traits_list:
# 		var x = load("res://character/personality/facets/" + i + ".tres")
# 		var t = Facet.new(x)
# 		var value = Util.weighted_random(100, 5)
# 		_traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
# 	return _traits

# func determine_beliefs():
# 	var _traits: = {}
# 	var traits_list: Array = ['family']
# 	for i in traits_list:
# 		var x = load("res://character/personality/beliefs/" + i + ".tres")
# 		var t = Belief.new(x)
# 		var value = Util.weighted_random(100, 5)
# 		_traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
# 	return _traits

# func determine_goals():
# 	var goal_list = ['love']
# 	var resource = load("res://character/personality/goals/" + Util.choose(goal_list) + ".tres")
# 	var trait = Goal.new(resource)
# 	return  {'Goals': trait.get_trait_name()}
