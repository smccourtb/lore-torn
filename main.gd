extends Node2D

onready var character_generator: Resource = CharacterGenerator.new()
onready var character: PackedScene = preload("res://character/Character.tscn")
onready var resource_generator: Resource = ResourceGenerator.new()
var resource_node: PackedScene = preload("res://ResourceNode.tscn")

onready var grid = preload("res://resource/grid/cell_grid.tres")
onready var time = Time.new({'day':0, 'hour':0, 'minute':0, 'month':0, 'year':0}) # Use this to set the time of day when starting
var gaop: Resource
var tree_positions: PoolVector2Array = [Vector2(150, 100), Vector2(300,150)]
func _ready() -> void:
	for _i in range(1):
		var x = character_generator.generate_ancestor()
		Global.population.append(x)
		var new_character = character.instance()
		new_character.name = x.get_name()
		new_character.data = x
		add_child(new_character)
		new_character.position = Vector2(100, 100)
		
	var y = resource_generator.generate_tree("oak")
	var new_resource = resource_node.instance()
	new_resource.data = y
	new_resource.texture = y.texture
	new_resource.position = tree_positions[0]
	add_child(new_resource)
		
		

func _process(_delta: float) -> void:
#	time.advance(_delta) # Start the clock
#	print(time.get_time_as_dictionary())
	pass
