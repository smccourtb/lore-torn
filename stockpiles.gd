extends TextureRect


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var line_width: float = 2.0

onready var main = get_parent()
onready var cursor1 = main.get_node("Cursor")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	print(cursor1.cell)


func _draw():
	for i in Global.stockpiles:
		draw_rect(i.rect, Color(.5,.5,.5), false , line_width)

