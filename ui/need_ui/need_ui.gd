extends MarginContainer

onready var need_bar_container: HBoxContainer = $MC/HB
onready var need_bar: PackedScene = preload("res://ui/need_ui/NeedBar.tscn")


func setup_need_bars(needs):
	for need in needs.values():
		var new_need_bar: VBoxContainer = need_bar.instance()
		need_bar_container.add_child(new_need_bar)
		new_need_bar.setup(need)
