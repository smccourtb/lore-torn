extends Node
tool
onready var main = get_node("/root/Main")
export var DEBUG: bool = false
const map_grid = preload("res://resource/grid/map_grid.tres")
const chunk_grid = preload("res://resource/grid/chunk_grid.tres")
# we need to hold all the characters in the 'tribe'
var population := []
var resource_nodes := {"tree": {}, "mineral": {}, "plant": {}}
var jobs := ["chop", "mine", "gather", "carpenter"]
var items := {} # items that are on the ground, not in a stockpile
var stockpiles := []
var walkable_cells := [] # These are actually NON walkable cells
var map_data := {}
# map_data = {chunks:
#				cells:{tile: { tile_id:___, walkable:____}}
#				nodes:{ tree: {pos: node}, mineral: {pos, node}, plant: {pos, node}}
var pending_constructions = []

var workstation_orders = {"carpenters_workbench":{}}
var workstation_position

func _ready():
	SignalBus.connect("resource_removed", self, "_on_resource_Removed")
	SignalBus.connect("item_on_world_map", self, "_on_item_SpawnedOnMap")

func chunk_pos(position: Vector2):
	return chunk_grid.calculate_grid_coordinates(position)

func add_to_population(character: Character) -> void:
	self.population.append(character)

func remove_from_population(character: Character) -> void:
	self.population.erase(character)

func get_population() -> Array:
	return population

func get_resource_nodes(type: String) -> Dictionary:
	return resource_nodes.get(type, null)

func set_resource_node(type: String, key: Vector2, value: ResourceNode) -> void:
	resource_nodes[type][key] = value 

func remove_resource_node(type: String, key: Vector2) -> bool:
	return resource_nodes[type].erase(key)
	

func _on_resource_Removed(ref, pos) -> void:
	print(ref, " has been removed at ", pos)
	remove_resource_node(ref, pos)

func get_walkable_cells() -> Array:
	return walkable_cells
	
func _on_item_SpawnedOnMap(item_pos: Vector2, item_ref: int):
		items[item_pos] = item_ref
		walkable_cells.append(item_pos)
#		print("updating nav map")
#		main.pathfinder.update_navigation_map(get_walkable_cells())
		
