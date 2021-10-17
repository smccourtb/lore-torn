extends Node

# we need to hold all the characters in the 'tribe'
var population = []

var resource_nodes: = {}

var jobs: Array = ["chop", "mine", "gather", "carpenter"]

var items: = {}

var stockpiles: = []

var walkable_cells = []

var map_data: = {}
# map_data = {cells:{}, 
var pending_constructions = []

var workstation_orders = {"carpenters_workbench":[]}
# Some sort of global item to id thang: so 
# Right in the beginnning do it every every single item and resource and thing in the game
# oak_tree -> hash
# store in a dictionary
# i need the item
var workstation_position

const map_grid = preload("res://resource/grid/map_grid.tres")
const chunk_grid = preload("res://resource/grid/chunk_grid.tres")

func chunk_pos(position):
	return chunk_grid.calculate_grid_coordinates(position)

func _ready():
	SignalBus.connect("resource_removed", self, "_on_resource_Removed")
	
func _on_resource_Removed(ref, pos):
#	var chunk= map_data.map_grid.calculate_
	print("yerp")
	print(ref)

func find_resource_node(node: String, chunk_pos: Vector2, type: String = ""):
	# returns an array of positions of the specifed type of resource node
	# if a subtype is provided, returns a list with only those types of nodes
	
	# first we get the resource node dictionary in the map data of the type provided
	var node_list = map_data[chunk_pos].nodes[node]
	# if no subtype provided return the positions all nodes
	if !type:
		return node_list.keys()
	# if subtype is provided, find matching subtypes in list and return their positions
	var specified_nodes = []
	for i in node_list.keys():
		if node_list[i].subtype == type:
			specified_nodes.append(i)
	return specified_nodes

func find_item(type: String, chunk_pos: Vector2, item_id = null):
	var item_list = map_data[chunk_pos].items.get(type, [])
	if !item_id:
		return item_list


