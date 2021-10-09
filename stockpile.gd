extends Inventory
class_name Stockpile

var allowed: = []
var coords = []
var grid: Grid
var slot_coords: Array

func _init(allowed_items: Array, size, coordinates).(size) -> void:
	
	self.allowed = allowed_items
	self.coords = coordinates
	var start = coords[0]
	var end = coords[1]
	var columns = (start.x - end.x) / 8
	var rows = (start.y - end.y) / 8
#	grid = Grid.new(Vector2(columns,rows), Vector2(8,8))
	slot_coords = get_slot_coordinates()
	
func get_slot_coordinates():
	var stockpile_coords = []
	var offset = Vector2(4,4)
	for y in grid.size.y:
		for x in grid.size.x:
			stockpile_coords.append(Vector2(coords[0].x + ((x+1)*offset.x), coords[0].y + ((y+1)*offset.y)))
	return stockpile_coords

func action(character, held_item):
	var x = .add_item(held_item)
	held_item.position = slot_coords[x]
	character.get_parent().add_child(held_item)
	character.held = null
	return true

func check_if_full():
	for i in items:
		if i != null:
			return true
	return false
