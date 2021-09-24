extends Resource
class_name PersonalityTrait

var facet_resources: = []
var facets: = []

func _init(resource: PersonaltyTraitTemplate):
	facet_resources = resource.facets
	generate()
	print("FaCETS AFTER GENERATING: ", facets)
func generate() -> void:
	for f in facet_resources:
		print(f.name)
		print("RESOURCE FROM FACET LIST IN PERSONALITY TRAITS: ", f)
		facets.append(Facet.new(f))

func get_total_value() -> int:
	var total: int = 0
	for i in facets:
		total += i.get_current_value()
	return total