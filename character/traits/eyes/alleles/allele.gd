extends Resource
class_name Allele
# Codominant: Both traits are present but not mixed.

# Incomplete Dominance: Both traits are mixed and creates a new variant

# Dominant: Overules the other trait

#Recessive: if dominant variant present it gets masked

# If an allele was a class it would be
#	dominant or recessive
#	if dominant
#		codominant or incomplete dominant
#		return choice
#   else
#   return recessive

export var dominant: int
export var codominant: Array
export var incomplete_dominance: Array
export var phenotype: String
export var id: int
