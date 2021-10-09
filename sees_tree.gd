extends BTConditional


func _pre_tick(_agent: Node, _blackboard: Blackboard) -> void:
	verified = Global.resource_nodes.size() > 0
