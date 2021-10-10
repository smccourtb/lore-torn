extends Control

onready var stockpiles = get_parent().get_parent().get_node("Stockpiles")
var show_stockpiles: bool = false
var chunk_cell: Vector2

func _ready() -> void:
	get_parent().get_parent().update()
	SignalBus.connect("chunk_pressed", self, "_onChunkGrid")
	SignalBus.connect("cell_pressed", self, "_on_AcceptPressed")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			get_parent().get_parent().stockpile_menu = false
			get_parent().get_parent().get_node("Stockpiles").visible = false
			queue_free()

func _on_Button_pressed() -> void:
	var zone_selector = load("res://ZoneGenerator.tscn").instance()
	get_parent().get_parent().get_node("Stockpiles").add_child(zone_selector)
	zone_selector.type = "stockpile"

func _on_AcceptPressed(grid_coord):
	if Global.map_data[chunk_cell][grid_coord].has("stockpile"):
		print(Global.map_data[chunk_cell][grid_coord].stockpile.allowed)
	
func _onChunkGrid(cell):
	print("CHUNK: ", cell)
#	var trees = []
	chunk_cell = cell
	# get all trees in chunk
	# get chunk
#	var chunk_data = Global.map_data[cell]
#	for i in chunk_data:
#		if chunk_data[i].has("tree"):
#			trees.append(i)
#	print("TREES IN CHUNK: ", trees)
