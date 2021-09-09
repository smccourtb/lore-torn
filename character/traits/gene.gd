extends Resource
class_name Gene

var genotype
var phenotype

# Maybe?
var incomplete_domance: Array


func _init(a, b):
	genotype = [a, b]
	phenotype = _determine_dominant_allele(genotype).phenotype

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

func get_genotype() -> Dictionary:
	return genotype
