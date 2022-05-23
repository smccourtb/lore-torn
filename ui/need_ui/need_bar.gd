extends VBoxContainer


onready var icon: TextureRect = $TextureRect
onready var progress_bar: TextureProgress = $TextureProgress
var progress_colors: Dictionary = {"red": Rect2(256, 296, 16, 32), "yellow": Rect2(464, 296, 16, 32), "green": Rect2(464, 632, 16, 32)}
onready var pop = $TextureRect/PopupPanel

func setup(need_data):
	icon.texture = load("res://ui/need_ui/icon/" + need_data.title + ".tres")
	name = need_data.title
	progress_bar.set_value(need_data.level)
	need_data.connect("need_changed", self, "_on_need_changed")
	

func _on_need_changed(value):
	$Tween.interpolate_property(progress_bar, "value", progress_bar.value, value, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()
	progress_bar.value = value
	if value > 30:
		progress_bar.texture_progress.region = progress_colors.green
	elif value > 10:
		progress_bar.texture_progress.region = progress_colors.yellow
	else:
		progress_bar.texture_progress.region = progress_colors.red


func _on_TextureRect_mouse_entered() -> void:
	pop.popup()
	pop.set_global_position(get_global_mouse_position() +Vector2(0, -pop.rect_size.y) )
	pop.get_node("MarginContainer/Label").text = name

