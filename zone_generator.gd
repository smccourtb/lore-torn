extends Node2D

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
onready var world_map = get_parent().get_node('TileMap')


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# We only want to start a drag if there's no selection.
			
			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
				print('raw: ', drag_start)
				print('drag start cvonerted: ', world_map.world_to_map(drag_start))
				print('convereted and convereted back: ', world_map.map_to_world(world_map.world_to_map(drag_start)))
		elif dragging:
			# Button released while dragging.

			dragging = false
			update()
			var drag_end = get_global_mouse_position()
			print('drag end: ', world_map.world_to_map(drag_end))
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			selected = space.intersect_shape(query)
#			get_parent().blackboard.data.chop_wood = true
			for item in selected:
				if !(item is KinematicBody2D):
					item.collider.set_selected(true)
			queue_free()


	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(world_map.map_to_world(world_map.world_to_map(drag_start)), world_map.map_to_world(world_map.world_to_map(get_global_mouse_position()) - world_map.world_to_map(drag_start))),
				Color(.5, .5, .5, .5), true)
		draw_rect(Rect2(world_map.map_to_world(world_map.world_to_map(drag_start)), world_map.map_to_world(world_map.world_to_map(get_global_mouse_position()) - world_map.world_to_map(drag_start))),
				Color(.5, .5, .5), false,2.0)
	