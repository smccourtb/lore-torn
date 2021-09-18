extends Node2D

onready var character_generator = preload("res://character/CharacterGenerator.gd").new()


func _ready() -> void:
	for _i in range(2):
		var node = load("res://character/Character.tscn").instance()
		var x = character_generator.generate_ancestor()
		add_child(node)
		node.data = x
		node.speed = randi() % 25
