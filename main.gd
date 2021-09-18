extends Node2D

onready var character_generator = preload("res://character/CharacterGenerator.gd").new()
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for _i in range(2):
		var node = load("res://character/Character.tscn").instance()
		var x = character_generator.generate_ancestor()
		
		add_child(node)
		node.data = x
		node.speed = randi() % 25
		print(x.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
