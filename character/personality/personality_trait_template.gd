extends Resource
class_name PersonaltyTraitTemplate


export var title: String
export var conflicting_traits: Array
export var grants_random_feeling: bool
export var grants_conditional_feeling: bool
export var random_feelings: Array
export var conditional_feelings: Array
export var grants_passive_need_modifier: bool
export var grants_conditional_need_modifier: bool

# can modify need values
# can create positive/negative feelings - self and others
	# - when acquiring an object
	# - randomly
# alter lifespan
# unlock social interaction choices
# they have conflicts meaning they cant have their conflict as another trait 
	# and when soicalizing if they have the oppositve trait there will be a negative modifier
# different reactions to recieving interactions

func trigger_random_feeling():
	# returns a feeling
	# grabs from random_feeling array
	# returns it
	# moodlet will be initialized in feeling_controller and dealt with there
	
#	object can have the same thing but like this {"feeling": Feeling, "emotion": "Sad", trait: "Gloomy"}
#	example object interaction
#   on interaction with exercise_equipment
#	if trigger.has("emotion"):
#   	if USER.primary_emotion == emotion_trigger:
#			send "create_feeling" signal with feeling as a parameter
	return

func trigger_feeling_on():
	return
