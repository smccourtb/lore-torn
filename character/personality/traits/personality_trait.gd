extends Resource
class_name PersonalityTrait

var title: String
var description: String
# holds trait ids
var conflicting_traits: Array
var random_feelings: Array
var owner_ref: Node
var triggers: Dictionary

func _init(resource: PersonaltyTraitTemplate, owner: Node) -> void:
	owner_ref = owner
	self.title = resource.title
	self.description = resource.description
	self.conflicting_traits = resource.conflicting_traits
	self.triggers = resource.triggers


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
	######## {"feeling",  "chance"}
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

	

