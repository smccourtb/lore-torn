extends Node2D

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
onready var world_map = get_parent().get_node('TileMap')
# TODO: add type to specify which type of zone to be genrated (ex. harvest resources, set stockpile, etc)
var type: String

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# We only want to start a drag if there's no selection.
			
			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
		elif dragging:
			# Button released while dragging.

			dragging = false
			if type == 'harvest':
				update()
			var drag_end = get_global_mouse_position()
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(query)

			for item in selected:
				if !(item.collider is KinematicBody2D): #<- would confirm its a character
					item.collider.set_selected(true)
					
			if type == "stockpile":
				# TODO: check if if intersects with another stockpile or non-empty tile
				var start = world_map.map_to_world(world_map.world_to_map(drag_start))
				var end = world_map.map_to_world(world_map.world_to_map(drag_end))
				var columns = (start.x - end.x) / 8
				var rows = (start.y - end.y) / 8
				var x = Stockpile.new(["wood"], abs(columns*rows), [start, end])
				Global.stockpiles.append(x)
			queue_free()
	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(world_map.map_to_world(world_map.world_to_map(drag_start)), world_map.map_to_world(world_map.world_to_map(get_global_mouse_position()) - world_map.world_to_map(drag_start))),
				Color(.5, .5, .5, .5), true)
		draw_rect(Rect2(world_map.map_to_world(world_map.world_to_map(drag_start)), world_map.map_to_world(world_map.world_to_map(get_global_mouse_position()) - world_map.world_to_map(drag_start))),
				Color(.5, .5, .5), false,2.0)
	
