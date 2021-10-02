extends Node2D
class_name PathFinding

var astar = AStar2D.new()
var tilemap : TileMap
var used_rect: Rect2
var half_cell_size: Vector2



func create_navigation_path(tilemap: TileMap):
	self.tilemap = tilemap
	
	half_cell_size = tilemap.cell_size / 2
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	#update_navigation_map(tilemap.node_resources)
	print('pathfinding done')
	
func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		
		astar.add_point(id, tile)

func connect_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
#		for x in range(3):
#			for y in range(3):
		for point in [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]:
			var target = tile + point  #Vector2(x-1, y-1)
			var target_id = get_id_for_point(target)
			
			if tile == target or not astar.has_point(target_id):
				continue
				
			astar.connect_points(id, target_id, true)
				
# these are world coordinates
func get_new_path(start: Vector2, end: Vector2) -> Array:
	var start_tile = tilemap.world_to_map(start)
	var end_tile = tilemap.world_to_map(end)
	var start_id = get_id_for_point(start_tile)
	var end_id = get_id_for_point(end_tile)
	
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return []
	
	var path_map = astar.get_point_path(start_id, end_id)
	
	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_world(point) + half_cell_size
		path_world.append(point_world)
		
	return path_world


func get_id_for_point(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x
	

# USE THIS IN A LOOP FOR EACH REGION IN MAP IN THE BEGINNING
func update_navigation_map(nodes_to_avoid):
	# TODO: This seems inefficient and I would rather set up a signal that updates the region
	for point in astar.get_points():
		astar.set_point_disabled(point, false)
	
	var obstacles = get_tree().get_nodes_in_group('obstacles')
	for obstacle in obstacles:
		print(obstacle)
#		if obstacle is TileMap:
#			var tiles = obstacle.get_used_cells()
#			for tile in tiles:
#				var id = get_id_for_point(tile)
#				if astar.has_point(id):
#					astar.set_point_disabled(id, true)
		if obstacle is StaticBody2D:
			var tiles = tilemap.world_to_map(obstacle.collision_shape.global_position)
			
			var id = get_id_for_point(tiles)
			if astar.has_point(id):
				print(true)
				astar.set_point_disabled(id, true)
	# This is the main way ill use for now
	for point in nodes_to_avoid:
		var id = get_id_for_point(point)
		if astar.has_point(id):
			astar.set_point_disabled(id, true)

