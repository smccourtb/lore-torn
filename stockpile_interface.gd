extends Control

onready var stockpiles = get_parent().get_parent().get_node("Stockpiles")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var show_stockpiles: bool = false

var mouse_pos
var chunk
var cell
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_parent().update()
		

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			get_parent().get_parent().stockpile_menu = false
			get_parent().get_parent().get_node("Stockpiles").visible = false
			queue_free()
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			if Global.map_data[chunk][cell].has("stockpile"):
				var s = Global.map_data[chunk][cell].stockpile
				print(s.allowed)
				print(s.items)
				print(s.rect)

func _on_Button_pressed() -> void:
	var zone_selector = load("res://ZoneGenerator.tscn").instance()
	get_parent().get_parent().get_node("Stockpiles").add_child(zone_selector)
	zone_selector.type = "stockpile"


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = get_global_mouse_position()
		chunk = Global.chunk_grid.calculate_grid_coordinates(mouse_pos)
		cell = Global.map_grid.calculate_grid_coordinates(mouse_pos)
			
