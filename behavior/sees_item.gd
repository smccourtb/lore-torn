extends BTConditional

# Used to create conditions. The condition is checked BEFORE ticking,
# and if the condition is met the child node is executed.
# The conditional then returns the same state as the child node, as 
# a normal decorator, not the result of the condition.
# If you want to know the result of the condition, store in the blackboard
# during _pre_tick().


func _pre_tick(_agent: CharacterController, _blackboard: Blackboard) -> void:
	verified = false
	if !Global.items.empty():
		verified = true


func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	if reverse and not ignore_reverse:
		verified = not verified
	
	if verified:
		return ._tick(agent, blackboard)
	return fail()


func _post_tick(_agent: CharacterController, _blackboard: Blackboard, _result: bool) -> void:
	pass

