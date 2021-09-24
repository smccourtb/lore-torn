extends Resource
class_name PersonalityTrait

var facet_resources: = []
var facets: = {}

func _init(resource: PersonaltyTraitTemplate) -> void:
	facet_resources = resource.facets
	generate()

func generate() -> void:
	for f in facet_resources:
		facets[f.name] = Facet.new(f)

func get_total_value() -> int:
	var total: int = 0
	for i in facets:
		total += facets[i].get_current_value()
	return total
