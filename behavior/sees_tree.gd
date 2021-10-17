extends BTConditional


func _pre_tick(_agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	if Global.resource_nodes.has("tree") and Global.resource_nodes.tree.size() > 0:
		verified = true
