extends Resource
class_name PersonalityTrait

var trait_name: String
var trait_descriptions: PoolStringArray


func get_description(trait_value) -> String:
	assert(trait_descriptions, "Variable trait_descriptions has not been set.")
	if trait_value >= 91:
		return trait_descriptions[6]
	elif trait_value >= 76:
		return trait_descriptions[5]
	elif trait_value >= 61:
		return trait_descriptions[4]
	elif trait_value > 40:
		return trait_descriptions[3]
	elif trait_value >= 25:
		return trait_descriptions[2]
	elif trait_value >= 10:
		return trait_descriptions[1]
	else:
		return trait_descriptions[0]


func get_trait_name() -> String:
	assert(trait_name, "Variable trait_name has not been set.")
	return trait_name
