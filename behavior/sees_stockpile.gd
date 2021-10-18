extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	verified = false 
	var stockpile = agent.find_applicable_stockpiles(_blackboard.data.item_to_haul)
	if !stockpile.empty():
		print("S:", stockpile)
		stockpile = stockpile.values()[0]
	if stockpile and !Global.items.empty():
			verified = true

