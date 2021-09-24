extends Resource
class_name Facet

export var name: String
export var possible_descriptions: PoolStringArray

var current_value: int
var current_description: String

func _init(resource: FacetTemplate):
	print('RESOURCE IN FACET: ', resource)
	name = resource.name
	possible_descriptions = resource.descriptions
	current_value = Util.weighted_random(100, 5)
	current_description = set_description(current_value)

func set_description(var value: int):
	assert(possible_descriptions, "Variable descriptions has not been set.")
	if value >= 91:
		return possible_descriptions[6]
	elif value >= 76:
		return possible_descriptions[5]
	elif value >= 61:
		return possible_descriptions[4]
	elif value > 40:
		return possible_descriptions[3]
	elif value >= 25:
		return possible_descriptions[2]
	elif value >= 10:
		return possible_descriptions[1]
	else:
		return possible_descriptions[0]
	
func get_name() -> String:
	return name

func get_current_value() -> int:
	return current_value

func set_current_value(value) -> void:
	current_value = value
	current_description = set_description(current_value)

func get_current_description() -> String:
	return current_description
