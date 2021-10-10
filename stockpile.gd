extends Inventory
class_name Stockpile

var allowed: = []
var start_coord: Vector2
var grid: Grid = Global.map_grid
var slot_coords: Array
var rect: Rect2

func _init(allowed_items: Array, columns, rows, start).(columns * rows) -> void:
	self.allowed = allowed_items
	self.start_coord = start
	self.rect = Rect2(grid.calculate_map_position(start)-Vector2(4,4), (Vector2(columns, rows)*8))
	slot_coords = get_slot_coordinates(columns, rows)
	update_map_data()
	
func get_slot_coordinates(columns, rows):
	var stockpile_coords = []
	for y in rows:
		for x in columns:
			stockpile_coords.append(start_coord + Vector2(x, y))
			# Use if using start_coord is a map coordinate NOT a grid coordinate
#			stockpile_coords.append(grid.calculate_map_position(start_coord) + 
#									Vector2(x * grid.cell_size.x, y * grid.cell_size.y))
	print(stockpile_coords)
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

func update_map_data():
	for i in slot_coords:
		var convert_to_map = grid.calculate_map_position(i)
		var chunk_pos = Global.chunk_grid.calculate_grid_coordinates(convert_to_map)
		Global.map_data[chunk_pos][i]["stockpile"] = self
