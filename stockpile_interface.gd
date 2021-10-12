extends Control

var show_stockpiles: bool = false
var chunk_cell: Vector2

func _ready() -> void:
	get_parent().get_parent().update()
	SignalBus.connect("chunk_pressed", self, "_onChunkGrid")
	SignalBus.connect("cell_pressed", self, "_on_AcceptPressed")
	show_stockpiles()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			get_parent().get_parent().stockpile_menu = false
			var piles_to_remove = get_tree().get_nodes_in_group("stockpiles")
			for i in piles_to_remove:
				i.queue_free()
			queue_free()

func _on_Button_pressed() -> void:
	var zone_selector = load("res://ZoneGenerator.tscn").instance()
	get_parent().get_parent().add_child(zone_selector)
	zone_selector.type = "stockpile"

func _on_AcceptPressed(grid_coord):
	print(Global.map_data[chunk_cell][grid_coord])
	if Global.map_data[chunk_cell][grid_coord].has("stockpile"):
		print(Global.map_data[chunk_cell][grid_coord].stockpile.allowed)
	
func _onChunkGrid(cell):
	print("CHUNK: ", cell)
	chunk_cell = cell

func show_stockpiles():
#	for i in Global.stockpiles:
#		var stockpile = Line2D.new()
#		var points = []
#		stockpile.width = 2
#		var point1 = Global.map_grid.calculate_map_position(i.start_coord) - Vector2(4,4)
#		var point2 = Vector2(point1.x + i.rect.size.x , point1.y)
#		var point3 = Vector2(point2.x, point2.y +i.rect.size.y)
#		var point4 = Vector2(point1.x, point3.y)
#		var point5 = point1
#		for p in [point1, point2, point3, point4, point5]:
#			points.append(p)
#		stockpile.points = points
#		stockpile.add_to_group("stockpiles")
#		get_parent().get_parent().add_child(stockpile)
	for i in Global.stockpiles:
		var stockpile = TileMap.new()
		stockpile.set_tileset(load("res://border.tres"))
		stockpile.cell_size = Vector2(8,8)
#		stockpile.position = i.start_coord
		for j in i.slot_coords:
			stockpile.set_cellv(j,0)
			stockpile.update_bitmask_area(j)
		stockpile.add_to_group("stockpiles")
		get_parent().get_parent().add_child(stockpile)
