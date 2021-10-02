extends Node2D

onready var character_generator: Resource = CharacterGenerator.new()
onready var character: PackedScene = preload("res://character/Character.tscn")
onready var resource_generator: Resource = ResourceGenerator.new()
var resource_node: PackedScene = preload("res://ResourceNode.tscn")

onready var grid = preload("res://resource/grid/cell_grid.tres")
onready var time = Time.new({'day':0, 'hour':0, 'minute':0, 'month':0, 'year':0}) # Use this to set the time of day when starting

var tree_positions: PoolVector2Array = [Vector2(150, 100), Vector2(300,150), Vector2(275,55), Vector2(95,95), Vector2(300,25),]

var population: Array = []
onready var pathfinder = get_node("Pathfinding")
onready var world_map = get_node("TileMap")

func _ready() -> void:
	var count = 0
	pathfinder.create_navigation_path(world_map)
	
	for _i in range(1):
		# Generates character DATA
		var x = character_generator.generate_ancestor()
		population.append(x)
		# Instance new CHARACTER NODE
		var new_character = character.instance()
		# set the character name
		new_character.name = x.get_name()
		# set the CHARACTER DATA to CHARACTER NODE 	
		new_character.data = x
		
		new_character.pathfinding = pathfinder
		# add it to the tree so you can SEE
		add_child(new_character)
		# and finally set the position
		new_character.position = Vector2(100, 100)
		
	for _i in range(5):
		var y = resource_generator.generate_tree("oak")
		var new_resource = resource_node.instance()
		new_resource.data = y
		new_resource.texture = y.texture
		new_resource.position = tree_positions[count]
		add_child(new_resource)
		count += 1
		
		

func _process(_delta: float) -> void:
#	time.advance(_delta) # Start the clock
#	print(time.get_time_as_dictionary())
	pass
