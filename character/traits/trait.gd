extends Resource
class_name Trait # Used when multiple genes determine a trait ex. Eye Color = Iris Color + Iris Pigment

# These 2 are used if they have parents
export var gene_1: Resource # Father gene
export var gene_2: Resource # Mother gene

export var genes: Array = []

var trait: Array
var dominant_phenotype: String

func _init(genes: Array):
	setup_variables(genes)
	trait = generate_trait()
	dominant_phenotype = determine_dominant_phenotype()

func setup_variables(genes):
	# This assumes there is only 1 set of genes that determine this trait
	gene_1 = genes[0]
	gene_2 = genes[1]
	
func generate_trait():
	var A = gene_1.allele_1
	var B = gene_1.allele_2
	var X = gene_2.allele_1
	var Y = gene_2.allele_2
	var punnett = [[A,X],[A,Y],[B,X],[B,Y]]
	return Util.choose(punnett)
	
func determine_dominant_phenotype():
	var dominant
	var count: int = 0
	for i in trait:
		if i.dominant > count:
			dominant = i
		if !dominant:
			dominant = i
	
	return dominant.phenotype
		
# Accept multiple pairs of genes
