extends Resource
class_name PersonaltyTraitTemplate

export var id: int
export var title: String
export var description: String
# holds trait ids
export var conflicting_traits: Array
export var triggers: Dictionary = {
	"time":[],
	"social_proximity": [],
	"object_proximity": [],
	"social_interaction": [],
	"object_interaction": [],
	"complex": [],
}


# { 
#	"object_proximity": {object_id: {effect_type: String, effect: Resource}, ...}
#[object(s) that trigger], feeling_granted, need_modified/value
#	"character_proximity":  ,
#	"multiple":  ,
#	"random":  

var example_time_triggers = {
	"delay": 96, # minutes
	"chance": 10, # percentage
	"repeat": true, # bool
	"effect_type": "feeling", # [ feeling, need_modifier, stat_modifier, skill_modifier, interaction_unlocked, action_unlocked]
	"effect": "value",
}

var need_modifier_trigger = {
	"effect_type": "need",
	"effect": "need_id",
	"value": .05 # add to base decay rate modification (percentage)
}

var proximity_object = {
# object id that causes trigger
	2000:
		{
		"effect_type": "feeling",
		"effect": "feelind id",	
		}
}

var character_conditon = {
	"emotion": true,
	"need": true,
	"trait": true,
	"level": false,
	"value_desired": "angry"
}

