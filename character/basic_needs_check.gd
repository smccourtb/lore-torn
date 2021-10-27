extends BTConditional


func _pre_tick(agent: CharacterController, _blackboard: Blackboard) -> void:
	verified = false
	if agent.data.hunger_level < 10:
		verified = true
	# IDEA: change wait time to be maybe a base build time that everything is 
	#		based on
	# TODO: add material check just like when building a new item


