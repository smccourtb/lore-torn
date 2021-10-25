extends Node

const map_grid = preload("res://resource/grid/map_grid.tres")
const chunk_grid = preload("res://resource/grid/chunk_grid.tres")
# we need to hold all the characters in the 'tribe'
var population = []
var resource_nodes := {"tree": {}, "mineral": {}, "plant": {}}
var jobs := ["chop", "mine", "gather", "carpenter"]
var items  := {}
var stockpiles := []
var walkable_cells := []
var map_data := {}
# map_data = {chunks:
#				cells:{tile: { tile_id:___, walkable:____}}
#				nodes:{ tree: {pos: node}, mineral: {pos, node}, plant: {pos, node}}
var pending_constructions = []

var workstation_orders = {"carpenters_workbench":{}}
var workstation_position



func chunk_pos(position):
	return chunk_grid.calculate_grid_coordinates(position)

func _ready():
	SignalBus.connect("resource_removed", self, "_on_resource_Removed")
	var x = [{"type":'hi', "subtype": 'ho', "index":1, "id": 2}]

func _on_resource_Removed(ref, pos):
	print(ref, "has been removed at ", pos)

func get_walkable_cells() -> Array:
	return walkable_cells

func get_resource_nodes(type: String) -> Dictionary:
	return resource_nodes.get(type, null)
