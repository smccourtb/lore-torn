extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()


func _draw():
	for i in Global.stockpiles:
		draw_rect(i.rect, Color(.5,.5,.5,.5), false ,2.0)
