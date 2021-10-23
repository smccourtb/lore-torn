extends BTWait

# Waits for wait_time seconds, then succeeds. time_in_bb is the key where, 
# if desired, another amount can be specified. In that case, wait_time is overridden.






func _tick(agent: CharacterController, blackboard: Blackboard) -> bool:
	if !wait_time || wait_time == 0:
		wait_time = rand_range(.2, 1.5)
		
	
	yield(get_tree().create_timer(wait_time, false), "timeout")
	
	return succeed()
