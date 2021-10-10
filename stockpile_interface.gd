extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var show_stockpiles: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass
		

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ENTER:
			print("hi")
		if event.get_scancode() == KEY_D:
			show_stockpiles = !show_stockpiles
			if show_stockpiles:
				show()
			else:
				hide()

func _on_Button_pressed() -> void:
	var zone_selector = load("res://ZoneGenerator.tscn").instance()
	add_child(zone_selector)
	zone_selector.type = "stockpile"

func _draw():
	for i in Global.stockpiles:
		draw_rect(i.rect, Color(.5,.5,.5,.5), 2 ,false)
