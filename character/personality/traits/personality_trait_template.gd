extends Resource
class_name PersonaltyTraitTemplate

export var id: int
export var title: String
export var description: String
export var conflicting_traits: Array
export var triggers: Dictionary
# not implemented
export var unlocked_interactions: Dictionary # {object, social}
# experimental - not implemented
export var behaviors_unlocked: Dictionary

# { 
#	"object_proximity": {object_id: {effect_type: String, effect: Resource}, ...}
#[object(s) that trigger], feeling_granted, need_modified/value
#	"character_proximity":  ,
#	"multiple":  ,
#	"random":  

