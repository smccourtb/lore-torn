extends Resource
class_name GeneFactory

# This is only used intially when creating ancestors with no parents.
var allele_1: Resource
var allele_2: Resource

var possible_combinations: Array
var name: String
var id: int
var responsibility: String


func _init(x):
	possible_combinations = x
	_setup_alleles()

func _setup_alleles() -> void:
	# We need 2 alleles to make a gene
	for i in range(1,3):
		self.set("allele_" + str(i) , Util.choose(possible_combinations))

func generate_gene() -> Gene:
	return Gene.new(allele_1, allele_2)
