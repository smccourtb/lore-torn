extends Control

var show_stockpiles: bool = false
var chunk_cell: Vector2
var edit_mode:bool = false
var stockpile_selected: Stockpile
onready var create_stockpile_button = preload("res://ui/CreateStockpile.tscn")

func _ready() -> void:
	SignalBus.connect("chunk_pressed", self, "_onChunkGrid")
	SignalBus.connect("cell_pressed", self, "_on_AcceptPressed")
	SignalBus.connect("stockpile_created", self, "_on_StockpileCreated")
	build_user_stockpile_buttons()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			get_parent().get_parent().stockpile_menu = false
			hide_stockpile_border()
			queue_free()

func _on_CreateStockpile_pressed() -> void:
	var new_stockpile_generator = load("res://ui/StockpileType.tscn").instance()
	$MarginContainer/HBoxContainer.add_child(new_stockpile_generator)
	var nodes = $MarginContainer/HBoxContainer.get_children()
	for n in nodes:
		if n == $MarginContainer/HBoxContainer/MarginContainer:
			continue
		n.visible = false
	$MarginContainer/HBoxContainer/Return.visible = true
	
	
func _on_Button_pressed(toggled, s):
	if toggled:
		show_stockpile(s)
	else:
		hide_stockpile_border()
		

func _on_AcceptPressed(_grid_coord):
#	print(Global.map_data[chunk_cell][grid_coord])
	pass
	
func _onChunkGrid(cell):
	print("CHUNK: ", cell)
	chunk_cell = cell

func show_stockpile(s: Stockpile):
	var stockpile = TileMap.new()
	stockpile.set_tileset(load("res://resource/tilesets/border.tres"))
	stockpile.cell_size = Vector2(8,8)
	stockpile.set_modulate(s.color)
	for j in s.slot_coords:
		stockpile.set_cellv(j,0)
		stockpile.update_bitmask_area(j)
	stockpile.add_to_group("stockpiles")
	get_parent().get_parent().add_child(stockpile)


func _on_StockpileCreated(stockpile):
	show_stockpile(stockpile)


func _on_Return_pressed() -> void:
	get_node("MarginContainer/HBoxContainer/MarginContainer").queue_free()	
	build_user_stockpile_buttons()
	$MarginContainer/HBoxContainer/Return.visible = false
	$MarginContainer/HBoxContainer/CreateStockpile.visible = true
	hide_stockpile_border()

func build_user_stockpile_buttons():
	for i in Global.stockpiles:
		var button = Button.new()
		button.text = i.allowed.keys()[0]
		button.toggle_mode = true
		button.connect("toggled", self, "_on_Button_pressed", [i])
		$MarginContainer/HBoxContainer.add_child(button)

func hide_stockpile_border():
	var piles_to_remove = get_tree().get_nodes_in_group("stockpiles")
	for i in piles_to_remove:
		i.queue_free()
