extends BTConditional


func _pre_tick(_agent: CharacterController, _blackboard: Blackboard) -> void:
	verified = false
	if not Global.workstation_orders.carpenters_workbench.empty():
			verified = true
