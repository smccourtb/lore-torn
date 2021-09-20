extends Node2D

onready var character_generator: Resource = preload("res://character/CharacterGenerator.gd").new()
onready var grid = preload("res://resource/grid/cell_grid.tres")
onready var time = Time.new({"hour" : 4, "minute" : 55}) # Use this to set the time of day when starting

func _ready() -> void:
	for _i in range(2):
		var node = load("res://character/Character.tscn").instance()
		var x = character_generator.generate_ancestor()
		x.have_conversation()
		x.position = grid.calculate_grid_coordinates(Vector2(0,0))
		
		Global.population.push_back(x)
		print(Global.population[-1].position)
		add_child(node)
		node.data = x
