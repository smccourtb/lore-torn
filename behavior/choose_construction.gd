extends BTLeaf


func _tick(_agent: CharacterController, blackboard: Blackboard) -> bool:
	# pull the most recent construction and set it to target so nobody else
	# can choose the same construction
	var target = Global.pending_constructions.pop_back()
	if target:
		# save the construction object reference so we can build it when we get
		# its set position
		blackboard.set_data("construction", target)
		return succeed()
	return fail()
