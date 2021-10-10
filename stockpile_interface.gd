extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var show_stockpiles: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_parent().update()
		

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


