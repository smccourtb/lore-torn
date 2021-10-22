extends BTLeaf


func _tick(_agent: Node, blackboard: Blackboard) -> bool:
	# call the build method on construction
	blackboard.get_data("construction").build()
	# then erase it from the dictionary. returns true if found and erased
	if blackboard.data.erase("construction"):
		return succeed()
	return fail()
