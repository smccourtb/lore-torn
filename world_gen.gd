extends TileMap

const width = 8
const height = 8

# the new stuff. keep here until it works
const MAP_SIZE = Vector2(35,35)
var mouse_pos: Vector2
var current_chunk: Vector2
#const chunk_grid: Grid = preload("res://chunk_grid.tres")
var node_resources := []
const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}
#declares tile types
const tiles = {
	'ForgottenPlains_Dirt' : 9,
	'ForgottenPlains_Grass' : 10,
	'ForgottenPlains_Cliffs' : 11,
	'ForgottenPlains_Clifftop' : 12,
	'ForgottenPlains_WaterTile' : 14,
	'SilentSwamp_ForgottenPlains_Grass_Link' : 21,
	'IcyWilderness_Snow' : 22,
	'DesolateDesert_Sand0' : 23,
	'SilentSwampMurky_Grass2Mud_Link_WATER' : 24,
	'SilentSwampMurky_Grass2Water_Link' : 25,
	'SilentSwampMurky_Mud2Water_Link' : 26,
	'SilentSwampMurky_Water' : 27,
	'SilentSwampMurky_Grass2DarkGrass_Link' : 28,
	'SilentSwampMurky_Grass2Mud_Link' : 29,
	'SilentSwampMurky_Mud2DarkMud_Link' : 30,
	'SilentSwampMurky_TallGrass' : 31,
	'SilentSwampMurky_Grass' : 32,
	'SilentSwampMurky_TallDarkGrass' : 33,
	'SilentSwampMurky_DarkGrass' : 34,
	'SilentSwampMurky_ForgottenPlainsGrass_Link' : 35
}

export var renderdistance : int = 5 # Used if loading/unloading chunks
export var noiseScale : int = 1
export var roughnessScale : float = 1.0
export var treeRarity : float = 0.0015
export var waterHeight : float = -.500
export var mudHeight  : float = 10
export var grassHeight : float = 65
export var stoneHeight : float = 100

var chunk := {} # world_map_data
var walkable_cells := []
var current_tile : String
var current_moisture_value
var current_elevation_value
var biome_moisture_value
var biome_elevation_value
var current_biome
var playerxy = Vector2.ZERO
var direction: Vector2
var mapseed =  1

# Other TileMaps

# Objects
onready var resource_generator = ResourceGenerator.new()
onready var resource_node: PackedScene = preload("res://ResourceNode.tscn")

# OpenSimplexNoise
var biomeMoistureMap = OpenSimplexNoise.new()
var biomeElevationMap = OpenSimplexNoise.new()
var chunkElevationMap = OpenSimplexNoise.new()
var chunkMoistureMap = OpenSimplexNoise.new()
var treeMap = OpenSimplexNoise.new()




func _ready():
#	var timer = Timer.new()
#	timer.set_wait_time(0.1)
#	timer.set_one_shot(false)
#	timer.connect("timeout", self, "_on_ChunkTimer_timeout")
#	add_child(timer)
#	timer.start()
	randomize()
	if !mapseed:
		mapseed = randi()
	seed(mapseed)
	print("Seed: ", mapseed)
	# Generate elevation noise map for chunks
	chunkElevationMap.seed = mapseed  #Global.worldSeed
	chunkElevationMap.octaves = 3  #roughnessScale
	chunkElevationMap.period =  175   # noiseScale
	
	# Generate moisture noise map for chunks
	chunkMoistureMap.seed = mapseed
	chunkMoistureMap.octaves = 6
	chunkMoistureMap.period = 64
	
	# Generate moisture noise map for biomes
	biomeMoistureMap.seed = mapseed
	biomeMoistureMap.octaves = 1
	biomeMoistureMap.period = 1150    #noiseScale
	biomeMoistureMap.persistence = 4
	
	# Generate elevation noise map for biomes
	biomeElevationMap.seed = mapseed
	biomeElevationMap.octaves = 1
	biomeElevationMap.period = 350
	biomeElevationMap.persistence = .446
	biomeElevationMap.lacunarity = 2
	
	# Generate noise noise map for trees and various objects
	treeMap.seed = mapseed  #Global.worldSeed
	treeMap.octaves = 3
	treeMap.period = treeRarity
	
	generate_map()
#	node_overlay.draw(node_resources)
	print('Signal should fire but map is done')


func generate_map():
	var pos: Vector2
	for y in range(MAP_SIZE.y):
		for x in range(MAP_SIZE.x):
			pos = Vector2(x,y)
			if !chunk.has(pos):
				var c = Chunk.new(pos, self)
				chunk[pos] = c.chunk_data
# Used if loading/unloading chunks

#func _on_ChunkTimer_timeout():
#	var playerChunkPos = Vector2.ZERO
#	var playerChunkFloored = Vector2.ZERO
#	playerChunkPos.x = playerxy.x / width
#	playerChunkPos.y = playerxy.y / height
#	playerChunkFloored.x = floor(playerChunkPos.x)
#	playerChunkFloored.y = floor(playerChunkPos.y)
#
#	#Add chunk to list
#	var offset: Vector2
#	for y in range(renderdistance):
#		yield(get_tree().create_timer(0.1), "timeout")
#		for x in range(renderdistance):
## warning-ignore:integer_division
## warning-ignore:integer_division
#			offset = playerChunkFloored - Vector2(x-renderdistance/2,y-renderdistance/2)
#			if !ArrayContains(chunk, offset):
#				var c = Chunk.new(offset, groundmap, treeMap, biomeElevationMap, biomeMoistureMap, chunkElevationMap, chunkMoistureMap)
#				chunk.append(c)
#				c.PlaceTiles()
#				break
#			# INTERESTING COULD BE USEFUL
#			#print(chunk[0].tree_nodes, chunk[0].groundcluttermap.get_used_rect())
#
#	#Remove chunks too far away
#	for i in range(chunk.size()):
#		if chunk[i].pos.distance_to(playerChunkFloored) >= renderdistance+3:
#			chunk[i].RemoveTiles()
#			chunk.remove(i)
#			break


func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list


#func find_nodes(starting_position):
#	var closest_object:= {}
#	var unvisited = []  # array of unvisited tiles
#	var stack = []
#	for x in range(grid.size.x):
#		for y in range(grid.size.y):
#			unvisited.append(Vector2(x, y))
#	var current = grid.calculate_grid_coordinates(starting_position)
#	unvisited.erase(current)
#
#	# execute recursive backtracker algorithm
#	while !closest_object:
#		if closest_object.empty():
#			closest_object = search_chunk(starting_position, current)
#		var d = search_chunk(starting_position, current)
#		if !d.empty():
#			if d.keys()[0] < closest_object.keys()[0]:
#				closest_object = d
#		var neighbors = check_neighbors(current, unvisited)
#		print('YEPPPPPPPPPPPPPPPPPPP')
#		if neighbors.size() > 0:
#			var next = neighbors[randi() % neighbors.size()]
#			stack.append(current)
#			current = next
#			unvisited.erase(current)
#		elif stack:
#			current = stack.pop_back()
#
#	return closest_object.values()[0]
#
#
#func search_chunk(starting_position:Vector2, chunk_position:Vector2):
#	var closest_object
#	var dic = {}
#	if !node_resources[chunk_position].size() == 0 and grid.is_within_bounds(chunk_position):
#		for i in node_resources[chunk_position]:
#			var distance = stepify(i.distance_to(starting_position), .01)
#			if !closest_object:
#				closest_object = distance
#			else:
#				if distance < closest_object:
#					closest_object = distance
#			dic[distance] = i
#		var c = dic.keys()
#		closest_object = dic.keys().min()
#		return {closest_object:dic[closest_object]}
#	return {}




### GOALS ######
## 1. Generate map data
## 2. Place tiles
## 3. Place objects



# Map Generation begins here


func TileAtPos(var x, var y, biome):
	var height = chunkElevationMap.get_noise_2d(x,y)
	var moisture = chunkMoistureMap.get_noise_2d(x,y)
	var biome_moisture = biomeMoistureMap.get_noise_2d(x,y)
	##Get tile
	var tile = -1
	var biome_border
	match biome:
		"FORGOTTEN_PLAINS":
			if height > waterHeight:
				if moisture > 0.35:
					tile = tiles.ForgottenPlains_Dirt
				else:
					tile = tiles.ForgottenPlains_Grass
			elif height < waterHeight:
				tile = tiles.ForgottenPlains_WaterTile

		"SILENT_SWAMP_MURKY":
			biome_border = -0.012
			if biome_moisture <= 0 and biome_moisture > biome_border:
				tile = tiles.SilentSwampMurky_ForgottenPlainsGrass_Link
			elif height >= waterHeight-.02 and height <= waterHeight + .05:
				if moisture > .275:
					tile = tiles.SilentSwampMurky_Mud2Water_Link
				else:
					tile = tiles.SilentSwampMurky_Grass2Water_Link

			elif height >= waterHeight:
				if moisture > .32:
					tile = tiles.SilentSwampMurky_Mud2DarkMud_Link
				elif moisture < -0.33:
					tile = tiles.SilentSwampMurky_DarkGrass
				elif moisture <= -.2 and moisture >= -.33:
					tile = tiles.SilentSwampMurky_Grass2DarkGrass_Link
				elif moisture < .25:
					if moisture > .123 and height < -.185 :
						tile = tiles.SilentSwampMurky_TallGrass
					else:
						tile = tiles.SilentSwampMurky_Grass
				elif moisture >= .25:
					tile = tiles.SilentSwampMurky_Grass2Mud_Link

			elif height < waterHeight:
				# "Deep Water"
				tile = tiles.SilentSwampMurky_Water

		"DESOLATE_DESERT":
			tile = tiles.DesolateDesert_Sand0

		"ICY_WILDERNESS":
			tile = tiles.IcyWilderness_Snow

	return tile


func getBiome(e, m):
	if (e > 0.65):
			return 'ICY_WILDERNESS';
	else: 
		if (m < 0): return 'SILENT_SWAMP_MURKY';
		if (m < 0.45): return 'FORGOTTEN_PLAINS';
		else:
			return 'DESOLATE_DESERT';


class Chunk:
	# for the various dictionaries we want to know
	# the {chunk id, chunk position}, {cell id, cell position}, object reference
	
	# Chunk should take care of the data
	
	# Maybe i can add in links later? if i need to?? 
	#I still dont really understand all the way
	var pos : Vector2
	var map : TileMap
	var objects = {}
	var nodes := []
	var cells := {}
	var walkable: bool = true
	var chunk_data: Array

	func _init(world_pos, world_map):
		self.pos = world_pos
		self.map = world_map
		generate_data()
		return chunk_data
		
	func generate_data():
		place_tiles()
#		if nodes.size() > (16*16)/2:
#			walkable = false
		chunk_data = [cells, nodes, objects, walkable]
	func generate_nodes():
		pass
	func generate_objects():
		pass
			
	func place_tiles():
		#Place the tiles of the chunk
		for y in range(height):
			for x in range(width):
				
				# Get the tile position on the map
				var tilepos = pos * 8 + Vector2(x,y)
				#map.walkable_cells.append(map.map_grid.calculate_map_position(tilepos))
				#cells[map.map_grid.as_index(map.map_grid.calculate_map_position(tilepos))] = map.map_grid.calculate_map_position(tilepos)
				# Get noise values from ChunkMap(Elevation) and ChunkMap(Moisture)
				var chunk_height = map.chunkElevationMap.get_noise_2d(tilepos.x,tilepos.y)
				var chunk_moisture = map.chunkMoistureMap.get_noise_2d(tilepos.x,tilepos.y)
				
				# Get noise values from biomeMap(Elevation) and biomeMap(Moisture)
				var biome_value = map.biomeElevationMap.get_noise_2d(tilepos.x,tilepos.y)
				var moisture_value = map.biomeMoistureMap.get_noise_2d(tilepos.x,tilepos.y)
				
				# Use values from above to decide current biome the tile to be placed is in.
				var biome = map.getBiome(biome_value, moisture_value)
				
				# Use biome and tile position information to decide which tile to place.
				var id = map.TileAtPos(tilepos.x, tilepos.y, biome)
				
				# If water, 50% chance to add a cat tail.
#				if id == tiles.ForgottenPlains_WaterTile:
#					if Util.chance(.5):
#						map.groundcluttermap.set_cell(tilepos.x, tilepos.y, 20)

				if id == tiles.ForgottenPlains_Grass:
#					map.set_cell(tilepos.x, tilepos.y, 10)
#					map.update_bitmask_area(tilepos)
					
					# TODO: Still need to play around with the variables. Start looking into sub biomes,
					# and taking out the randomness of tiles. (Util.choose)
					var treeNoise = stepify(map.treeMap.get_noise_2d(tilepos.x,tilepos.y), .01)
					
					

					# This is for the trees
					if chunk_height < -.1:
						if treeNoise >=.4:
							
							var tree = map.resource_generator.generate_tree("oak")
							var new_resource = map.resource_node.instance()
							new_resource.data = tree
							new_resource.texture = tree.texture
							new_resource.position = map.map_to_world(tilepos) + Vector2(4,4)
							map.get_parent().call_deferred('add_child', new_resource)
#							Global.resource_nodes.append(new_resource)
#							nodes[tree.position] = tree
							#map.walkable_cells.erase(map.map_grid.calculate_map_position(tilepos))
#					if chunk_height > 0.01 and chunk_height < 0.04:
#						map.set_cell(tilepos.x, tilepos.y, tiles.ForgottenPlains_Dirt)
#						map.update_bitmask_area(tilepos)

					

#				else:
#					map.set_cell(tilepos.x, tilepos.y, id)
#					map.update_bitmask_area(tilepos)

	func RemoveTiles():
		#Remove the tiles of the chunk
		if objects:
			for t in objects:
				t.queue_free()

		for y in range(height):
			for x in range(width):
				var tilepos = pos*16 
				map.set_cell(tilepos.x + x, tilepos.y + y, -1)
				map.groundcluttermap.set_cell(tilepos.x+x,tilepos.y+y, -1)
