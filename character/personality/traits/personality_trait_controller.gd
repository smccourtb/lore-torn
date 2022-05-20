extends Resource
class_name PersonalityTraitController

var owner_ref: Node
var traits: Dictionary
var personality_trait_resources: Resource = preload("res://character/personality/traits/personality_traits.tres")


func _init(profile: Array, owner: Node) -> void:
	owner_ref = owner
	generate_traits(profile)
	SignalBus.connect("character_entered_proximity", self, "_on_character_entered_proximity")
	SignalBus.connect("object_entered_proximity", self, "_on_object_entered_proximity")


func create_new_personality_trait(trait_id: int, owner_ref: Node):
	# get conflicting traits of that trait id and check existing traits 
	# conflicting conditions
	if not check_trait_conflicts(trait_id):
		var new_trait: PersonalityTrait = PersonalityTrait.new(personality_trait_resources.resources[trait_id], owner_ref)
		traits[trait_id] = new_trait
	else:
		print("Personality Trait was not generated due to conflicting traits")


func generate_traits(profile):
	for i in profile:
		var new_trait: PersonalityTrait = create_new_personality_trait(i.id, owner_ref)


func check_trait_conflicts(trait_to_add: int) -> bool:
	if traits.size():
		for i in traits.values():
			if not trait_to_add in i.conflicting_traits: 
				return true
	return false


func _on_character_entered_proximity(body: KinematicBody2D):
	pass


func _on_object_entered_proximity(body: StaticBody2D):
	# Scenario: dude loves trees. If hes around them he gets happy
	# check trait triggers
	var applicable_triggers: Array = get_applicable_object_triggers(body.id)
	for i in applicable_triggers:
		execute_trigger(i)
	pass

func get_applicable_object_triggers(object_id: int):
	var object_triggers: Array
	for i in traits.values():
		if i.triggers.object_proximity.size():
			if object_id in i.triggers.object_proximity.keys():
				object_triggers.push_back(i.triggers.object_proximity[object_id])
	return object_triggers

func execute_trigger(trigger: Dictionary):
	if trigger.effect_type == "feeling":
		SignalBus.emit_signal("create_feeling", trigger.effect.id)
	if trigger.effect_type == "need_modification":
		SignalBus.emit_signal("modify_need", trigger.effect, trigger.value)
	
