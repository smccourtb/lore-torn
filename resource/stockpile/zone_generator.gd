extends Node2D

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
var item: Dictionary
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
			# Then we need to flag the ResourceNodes
			for i in selected:
				if i.collider is ResourceNode:
					i.collider.set_selected(true)
					
			if type == "stockpile":
				var start = Global.map_grid.calculate_grid_coordinates(drag_start)
				var end = Global.map_grid.calculate_grid_coordinates(drag_end)
				var rect = Rect2(start, (end-start) + Vector2(1,1))
				var x = Stockpile.new(item, rect)
				Global.stockpiles.append(x)
				# TODO: tie into a function that sets the tile coord data in map_data
				SignalBus.emit_signal("stockpile_created", x)
				
			queue_free()
	if event is InputEventMouseMotion and dragging:
		update()

func _draw():
	if dragging:
		draw_rect(Rect2(Global.map_grid.calculate_map_position(Global.map_grid.calculate_grid_coordinates(drag_start)) - Vector2(4,4), Global.map_grid.calculate_map_position(Global.map_grid.calculate_grid_coordinates(get_global_mouse_position()) - Global.map_grid.calculate_grid_coordinates(drag_start))+ Vector2(4,4)) ,
				Color(.5, .5, .5, .5), true)
		draw_rect(Rect2(Global.map_grid.calculate_map_position(Global.map_grid.calculate_grid_coordinates(drag_start)) - Vector2(4,4), Global.map_grid.calculate_map_position(Global.map_grid.calculate_grid_coordinates(get_global_mouse_position()) - Global.map_grid.calculate_grid_coordinates(drag_start))+ Vector2(4,4)),
				Color(.5, .5, .5), false,2.0)
