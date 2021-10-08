extends BTConditional


func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	verified = Global.resource_nodes.size() > 0
