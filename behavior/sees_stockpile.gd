extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false
	var items = ["wood", "mineral", "plant"]
	
	for i in items:
		var stockpile = agent.find_applicable_stockpile(i)
		if stockpile and Global.items.has(i):
			verified = true

