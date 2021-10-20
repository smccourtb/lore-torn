extends Node

# we need to hold all the characters in the 'tribe'
var population = []

var resource_nodes: = {"tree": {}, "mineral": {}, "plant": {}}

var jobs: Array = ["chop", "mine", "gather", "carpenter"]

var items: = {}

var stockpiles: = []

var walkable_cells = []

var map_data: = {}
# map_data = {chunks:
#				cells:{tile: { tile_id:___, walkable:____}}
#				nodes:{ tree: {pos, data}, mineral: {pos, data}, plant: {pos, data}}


var pending_constructions = []

var workstation_orders = {"carpenters_workbench":{}}
var workstation_position

const map_grid = preload("res://resource/grid/map_grid.tres")
const chunk_grid = preload("res://resource/grid/chunk_grid.tres")

func chunk_pos(position):
	return chunk_grid.calculate_grid_coordinates(position)

func _ready():
	SignalBus.connect("resource_removed", self, "_on_resource_Removed")
	
func _on_resource_Removed(ref, pos):
	print(ref, "has been removed at ", pos)
