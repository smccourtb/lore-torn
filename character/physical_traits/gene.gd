extends Resource
class_name Gene

var genotype: Array
var phenotype: String
var id: int

func _init(a, b):
	genotype = [a, b]
	phenotype = _determine_dominant_allele(genotype).phenotype
	# Might use this in a lookup table if performance becomes an issue
	id = hash(str(genotype[0].id + genotype[1].id) + phenotype)

func _determine_dominant_allele(alleles: Array) -> Resource:
	var dominant
	var count: int = 0
	for i in alleles:
		if i.dominant > count:
			dominant = i
		if !dominant:
			dominant = i
	return dominant

func get_phenotype() -> String:
	return phenotype

func get_genotype() -> Array:
	return genotype
