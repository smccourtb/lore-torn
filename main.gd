extends Node2D

onready var character_generator: Resource = CharacterGenerator.new()
onready var character: PackedScene = preload("res://character/Character.tscn")


#onready var time = Time.new({'day':0, 'hour':0, 'minute':0, 'month':0, 'year':0}) # Use this to set the time of day when starting
onready var job_assigner = preload("res://JobAssigner.tscn")

onready var pathfinder = get_node("Pathfinding")
onready var world_map = get_node("TileMap")
onready var cursor1 = get_node("Cursor")
onready var cursor2 = get_node("Cursor2")

var stockpile_menu: bool = false

var chunk_cell: Vector2

func _ready() -> void:
	pathfinder.create_navigation_path(world_map)
	
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
			if !stockpile_menu:
				$Cursor2.visible = !$Cursor2.visible
				var stockpile_interface = load("res://StockpileInterface.tscn").instance()
				$CanvasLayer.add_child(stockpile_interface)
				stockpile_menu = true
		if event.get_scancode() == KEY_ESCAPE:
			$Cursor2.visible = !$Cursor2.visible
			
				
	

