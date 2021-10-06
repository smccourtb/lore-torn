class_name ResourceGenerator
extends Resource

var resource_node: PackedScene = preload("res://ResourceNode.tscn")
var trees: Dictionary = {"oak": "res://resource/nodes/trees/oak_tree.tres"}
var rocks: Dictionary
var plants: Dictionary

func _init():
	pass

func generate_tree(type: String):
	var tree = TreeNode.new(load(trees[type]))
	return tree
	
func generate_rock(_type: String):
	pass
	
func generate_plant(_type: String):
	pass
	
func generate_node(_type: String, _subtype: String):
	pass
