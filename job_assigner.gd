extends Control

onready var container = get_node("VBoxContainer")
onready var job_row = preload("res://JobAssignerRow.tscn")
onready var header = get_node("VBoxContainer/Header/HBoxContainer")

var column_size = 175


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


