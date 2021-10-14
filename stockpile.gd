extends Inventory
class_name Stockpile

var allowed: = []
var start_coord: Vector2
var grid: Grid = Global.map_grid
var slot_coords: Array
var rect: Rect2
var excluded_coords: Array
var color: Color

func _init(allowed_items: Array, columns, rows, start).(columns * rows) -> void:
	self.allowed = allowed_items
	self.start_coord = start
	self.rect = Rect2(grid.calculate_map_position(start)-Vector2(4,4), (Vector2(columns, rows)*8))
	slot_coords = get_slot_coordinates(columns, rows)
	update_map_data()
	remove_occupied_tiles()
	set_color()
	
func get_slot_coordinates(columns, rows):
	var stockpile_coords = []
	for y in rows:
		for x in columns:
			stockpile_coords.append(start_coord + Vector2(x, y))
			# Use if using start_coord is a map coordinate NOT a grid coordinate
#			stockpile_coords.append(grid.calculate_map_position(start_coord) + 
#									Vector2(x * grid.cell_size.x, y * grid.cell_size.y))
	return stockpile_coords

func action(character, held_item):
	var x = .add_item(held_item)
	held_item.position = Global.map_grid.calculate_map_position(slot_coords[x])
	character.get_parent().add_child(held_item)
	character.held = null

func check_if_full():
	var count = 0
	for i in items:
		if i != null:
			count += 1
	if count >= items.size():
		return true
	return false

func remove_occupied_tiles():
	for i in excluded_coords:
		slot_coords.erase(i)

func update_map_data():
	# also finds cells in stockpile that are already occupied
	for i in slot_coords:
		var convert_to_map = grid.calculate_map_position(i)
		var chunk_pos = Global.chunk_grid.calculate_grid_coordinates(convert_to_map)
		if !(Global.map_data[chunk_pos][i].has("stockpile")):
			Global.map_data[chunk_pos][i]["stockpile"] = self
		else:
			excluded_coords.append(i)
		if Global.map_data[chunk_pos][i].has("tree"):
			excluded_coords.append(i)

func set_color():
	if "wood" in allowed:
		color =  Color( 0.52, 0.41, 0.12, 1 )
