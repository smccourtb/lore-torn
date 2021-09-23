extends Resource
class_name PersonalityTrait

export var facets: = [] # facet Resources

func generate() -> void:
	for f in facets:
		var y = Facet.new(f)
		print(y.get_name())
		print(y.get_current_description())