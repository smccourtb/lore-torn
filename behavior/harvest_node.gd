extends BTLeaf

var target_node: Vector2
var node_type: String

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	target_node = Global.map_grid.calculate_map_position(blackboard.get_data("target_node"))
	node_type = blackboard.get_data("target_node_type")
	# Erase from resource node dictionary
	Global.resource_nodes[node_type].erase(Global.map_grid.calculate_grid_coordinates(target_node))
	# Get node reference
	var node = Global.map_data[Global.chunk_grid.calculate_grid_coordinates(target_node)].nodes[node_type]
	# the actual harvest action, deletes node, drops items
	node[target_node].action(agent)
	# erase from map data
	node.erase(target_node)
	# clear the blackboard 
	blackboard.data.erase("target_node_type")
	blackboard.data.erase("target_node")
	return succeed()
