extends BTConditional


func _pre_tick(_agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	if Global.resource_nodes.has("mineral") and Global.resource_nodes.mineral.size() > 0:
		verified = true
