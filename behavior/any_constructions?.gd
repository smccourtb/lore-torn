extends BTConditional


func _pre_tick(_agent: CharacterController, _blackboard: Blackboard) -> void:
	verified = false
	if !Global.pending_constructions.empty():
		verified = true
	# IDEA: change wait time to be maybe a base build time that everything is 
	#		based on
	# TODO: add material check just like when building a new item

