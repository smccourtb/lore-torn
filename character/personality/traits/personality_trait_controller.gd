extends Resource
class_name PersonalityTraitController

var owner_ref: Resource
var traits: Dictionary
var personality_trait_resources: Resource = preload("res://character/personality/traits/personality_traits.tres")

signal add_time_trigger(id, delay)

func _init(profile: Array, owner: Resource) -> void:
	owner_ref = owner
	generate_traits(profile)
	SignalBus.connect("character_entered_proximity", self, "_on_character_entered_proximity")
	SignalBus.connect("object_entered_proximity", self, "_on_object_entered_proximity")


func create_new_personality_trait(trait_id: int, owner_ref: Resource):
	# get conflicting traits of that trait id and check existing traits 
	# conflicting conditions
	if not check_trait_conflicts(trait_id):
		var new_trait: PersonalityTrait = PersonalityTrait.new(personality_trait_resources.resources[trait_id], owner_ref)
		setup_triggers(new_trait.triggers)
		traits[trait_id] = new_trait
	else:
		print("Personality Trait was not generated due to conflicting traits")


func generate_traits(profile):
	for i in profile:
		create_new_personality_trait(i.id, owner_ref)


func check_trait_conflicts(trait_to_add: int) -> bool:
	if traits.size():
		for i in traits.values():
			if not trait_to_add in i.conflicting_traits: 
				return true
	return false


func _on_character_entered_proximity(body: KinematicBody2D):
	var applicable_triggers: Array = get_applicable_social_triggers(body)
	for trigger in applicable_triggers:
		execute_trigger(trigger)
# Need a signal for object use
# need a signal for interaction
# need a signal for time passed 
func _on_object_entered_proximity(body: StaticBody2D) -> void:
	var applicable_triggers: Array = get_applicable_object_triggers(body.id)
	for trigger in applicable_triggers:
		execute_trigger(trigger)


func get_applicable_object_triggers(object_id: int) -> Array:
	var object_triggers: Array
	for i in traits.values():
		if i.triggers.object_proximity.size():
			for j in i.triggers.object_proximity:
				if j.has(object_id):
					object_triggers.push_back(j[object_id])
	return object_triggers

func get_applicable_social_triggers(body) -> Array:
	var social_triggers: Array
	for i in traits.values():
		if i.triggers.social_proximity.size():
			for j in i.triggers.social_proximity:
				if j.complex:
					if not check_trigger_conditional(j, body):
						continue
				social_triggers.push_back(j)
	return social_triggers

func check_trigger_conditional(trigger, body: KinematicBody2D):
	if trigger.emotion:
		if body.data.personality.emotion_controller.get_primary_emotion().name == trigger.value:
			return true
	if trigger.trait:
		if body.data.personality.personal_trait_controller.traits.has(trigger.value):
			return true
	return false


func execute_trigger(trigger: Resource) -> void:
	if trigger.effect_type == "feeling":
		SignalBus.emit_signal("create_feeling", trigger.effect)
	# skill modifier - not implemented
	# stat modifier (like speed) - not implemented
	# add interactions
	# add behaviors

func setup_time_triggers(triggers: Array):
	for trigger in triggers:
		if trigger.random:
			if Util.chance(trigger.chance):
				trigger.delay = Util.randi_range(240, 4320) # 4 hours - 3 days
			else:
				return
		SignalBus.emit_signal("add_time_trigger", trigger)


func setup_triggers(triggers: Dictionary):
	if triggers.time.size():
		setup_time_triggers(triggers.time)
	if triggers.object_proximity.size():
		pass
	if triggers.social_proximity.size():
		pass
	if triggers.complex.size():
		pass



# if character comes nearby:
#	- with certain emotion
#		- character.primary_emotion , effect
#	- with certain trait(s)
#	- holding a certain object or type of object <- advanced for now
#   - if its a certain character (good/bad relationship)
#   - if character has certain genetic trait
#   - character has a need level
#   - character has a certain stat level ( not quite implemented)
#	- character has good/bad proficiency in a skill

# when interacting with an object
# if an object is in character's proximity
# when interacting with another character
# time
#	- time since last object interaction
# random


# effects
#	- feelings
#	- need modifier
#	- interactions
#	- behaviours
