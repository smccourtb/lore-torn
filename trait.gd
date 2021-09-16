extends Resource
class_name Trait

var trait_name: String
var trait_description: String

func _init(t) -> void:
	trait_name = t.name

func get_description(trait_value) -> String:
	if trait_value >= 91:
		return trait.descriptions[6]
	elif trait_value >= 76:
		return trait.descriptions[5]
	elif trait_value >= 61:
		return trait.descriptions[4]
	elif trait_value > 40:
		return trait.descriptions[3]
	elif trait_value >= 25:
		return trait.descriptions[2]
	elif trait_value >= 10:
		return trait.descriptions[1]
	else:
		return trait.descriptions[0]