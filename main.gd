extends Node2D

onready var character_generator: Resource = CharacterGenerator.new()
onready var character: PackedScene = preload("res://character/Character.tscn")
onready var resource_generator: Resource = ResourceGenerator.new()
var resource_node: PackedScene = preload("res://ResourceNode.tscn")

onready var chunk_grid = preload("res://resource/grid/chunk_grid.tres")
onready var map_grid = preload("res://resource/grid/map_grid.tres")

onready var time = Time.new({'day':0, 'hour':0, 'minute':0, 'month':0, 'year':0}) # Use this to set the time of day when starting
onready var job_assigner = preload("res://JobAssigner.tscn")

onready var pathfinder = get_node("Pathfinding")
onready var world_map = get_node("TileMap")
onready var cursor1 = get_node("Cursor")
onready var cursor2 = get_node("Cursor2")


var chunk_cell: Vector2

func _ready() -> void:
	pathfinder.create_navigation_path(world_map)
	cursor1.connect("accept_pressed", self, "_onChunkGrid")
	
	cursor2.connect("accept_pressed", self, "_on_AcceptPressed")
	
	for _i in range(1):
		# Generates character DATA
		var x = character_generator.generate_ancestor()
		Global.population.append(x)
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
		new_character.position = Vector2(Util.randi_range(0, 300), Util.randi_range(0, 300))

func _process(_delta: float) -> void:
#	time.advance(_delta) # Start the clock
#	print(time.get_time_as_dictionary())
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_J:
			var job_menu = job_assigner.instance()
			$CanvasLayer.add_child(job_menu)
		
		# TODO: change to its own menu where you can pick what type of zone you want to generate 
		if event.get_scancode() == KEY_H:
			var zone_selector = load("res://ZoneGenerator.tscn").instance()
			add_child(zone_selector)
			zone_selector.type = "harvest"
		if event.get_scancode() == KEY_P:
			
			var zone_selector = load("res://ZoneGenerator.tscn").instance()
			add_child(zone_selector)
			zone_selector.type = "stockpile"
			

func _on_AcceptPressed(grid_coord):
	
	var index = map_grid.as_index(grid_coord)
	print(world_map.chunk[chunk_cell][index])
	
func _onChunkGrid(cell):
	print(cell)
	var trees = []
	chunk_cell = cell
	# get all trees in chunk
	# get chunk
	var chunk_data = world_map.chunk[cell]
	for i in chunk_data:
		print(i)
		if chunk_data[i].has("tree"):
			trees.append(i)
	print(trees)
	
