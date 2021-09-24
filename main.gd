extends Node2D

onready var character_generator: Resource = preload("res://character/CharacterGenerator.gd").new()
onready var grid = preload("res://resource/grid/cell_grid.tres")
onready var time = Time.new({'day':0, 'hour':0, 'minute':0, 'month':0, 'year':0}) # Use this to set the time of day when starting

func _ready() -> void:
	for _i in range(100):
		var node = load("res://character/Character.tscn").instance()
		var x = character_generator.generate_ancestor()

func _process(delta: float) -> void:
	# time.advance(delta) # Start the clock
	pass