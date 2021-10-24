extends Inventory
class_name Stockpile

var allowed: = {}
var grid: Grid = Global.map_grid
var slot_coords: Array # grid coordinates (tile)
var rect: Rect2
var color: Color

func _init(allowed_items: Dictionary, rectangle: Rect2).(rectangle.size.x * rectangle.size.y) -> void:
	self.allowed = allowed_items
	if rectangle.size < Vector2(0,0):
		rectangle.position += rectangle.size
		rectangle.size = Vector2(abs(rectangle.size.x), abs(rectangle.size.y))
	self.rect = rectangle
	slot_coords = get_slot_coordinates(rectangle.size)
	update_map_data()
	
	set_color()
	
func get_slot_coordinates(size: Vector2) -> Array:
	var stockpile_coords: = []
	for y in size.y:
		for x in size.x:
			stockpile_coords.append(rect.position + Vector2(x, y))
			# Use if using start_coord is a map coordinate NOT a grid coordinate
#			stockpile_coords.append(grid.calculate_map_position(start_coord) + 
#									Vector2(x * grid.cell_size.x, y * grid.cell_size.y))
	return stockpile_coords

func store_item(character: KinematicBody2D, item: Item):
	var index: int = .add_item(item)
	var pos: Vector2 = grid.calculate_map_position(slot_coords[index])
	item.set_position(pos)
	character.get_parent().add_child(item)

func remove_occupied_tiles(tiles: Array) -> void:
	for i in tiles:
		slot_coords.erase(Global.map_grid.calculate_grid_coordinates(i))

func update_map_data():
	var excluded_coords: Array = []
	# also finds cells in stockpile that are already occupied
	for i in slot_coords:
		var convert_to_map = grid.calculate_map_position(i)
		var chunk_pos = Global.chunk_grid.calculate_grid_coordinates(convert_to_map)
		var converted_i = Global.map_grid.calculate_map_position(i)
		if !(Global.map_data[chunk_pos].cells[i].has("stockpile")):
			Global.map_data[chunk_pos].cells[i]["stockpile"] = self
		else:
			excluded_coords.append(converted_i)
		if Global.map_data[chunk_pos].nodes.tree.get(converted_i, null):
			excluded_coords.append(converted_i)
		if Global.map_data[chunk_pos].nodes.mineral.get(converted_i, null):
			excluded_coords.append(converted_i)
		if Global.map_data[chunk_pos].nodes.plant.get(converted_i, null):
			excluded_coords.append(converted_i)
		remove_occupied_tiles(excluded_coords)

func set_color():
	if "wood" in allowed.keys():
		color =  Color( 0.52, 0.41, 0.12, 1 )

func get_start_coord() -> Vector2:
	return rect.position

func get_stored_item(index) -> Item:
	var item = items[index]
	if item:
		return items
	return null
