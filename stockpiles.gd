extends TextureRect


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var line_width: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()


func _draw():
	for i in Global.stockpiles:
		draw_rect(i.rect, Color(.5,.5,.5), false , line_width)


func _on_Stockpiles_gui_input(event: InputEvent) -> void:
	print(event)


func _on_Stockpiles_mouse_entered() -> void:
	print("HEYO")

