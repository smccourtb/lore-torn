extends BTConditional


func _pre_tick(_agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	if !Global.workstation_orders.carpenters_workbench.empty():
			verified = true
