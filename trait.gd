extends Resource
class_name Trait

var trait_name: String
var trait_descriptions: String

func _init(t) -> void:
	trait_name = t.name
	trait_descriptions = t.description
	

func get_description(trait_value) -> String:
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