extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	if !Global.pending_constructions.empty():
		verified = true

