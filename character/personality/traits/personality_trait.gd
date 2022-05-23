extends Resource
class_name PersonalityTrait

var title: String
var description: String
# holds trait ids
var conflicting_traits: Array
var owner_ref: Resource
var triggers: Dictionary

func _init(resource: PersonaltyTraitTemplate, owner: Resource) -> void:
	owner_ref = owner
	self.title = resource.title
	self.description = resource.description
	self.conflicting_traits = resource.conflicting_traits
	self.triggers = resource.triggers
	
	# check if there are any triggers based on time:
#		note the current time
#		start saving 'last_interacted' with interactions for certain objects and characters
#		every in game hour check the object you need to for time since last interacted with. trigger desired effect


