class_name ResourceGenerator
extends Resource

var resource_node: PackedScene = preload("res://resource/nodes/ResourceNode.tscn")
var tree: Dictionary = {"oak": "res://resource/nodes/trees/oak_tree.tres"}
var mineral: Dictionary = {"stone": "res://resource/nodes/minerals/stone.tres"}
var plant: Dictionary


func generate_tree(type: String):
	var resource_node_data = load(tree[type])
	var tree = resource_node.instance()
	tree.data = resource_node_data
	return tree
	
func generate_mineral(_type: String):
	pass
	
func generate_plant(_type: String):
	pass
	
func generate_node(type: String, subtype: String):
	var node_var = get(type)
	var resource_node_data = load(node_var[subtype])
	var node = resource_node.instance()
	node.data = resource_node_data
	return node
