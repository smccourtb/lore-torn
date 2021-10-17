extends Control

onready var container = get_node("VBoxContainer")
onready var job_row = preload("res://ui/JobAssignerRow.tscn")
onready var header = get_node("VBoxContainer/Header/HBoxContainer")

var column_size = 100


func _ready() -> void:
	header.get_node("MarginContainer").rect_min_size = Vector2(column_size, 0)
	for i in Global.jobs:
		var label = Label.new()
		label.text = i
		
		header.add_child(label)
	for i in Global.population:
		var new_row = job_row.instance()
		new_row.character_name = i.get_name()
		new_row.column_size = column_size
		new_row.ref = i
		container.add_child(new_row)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE or event.get_scancode() == KEY_J:
			queue_free()
