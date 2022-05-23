extends Camera2D

const MAX_ZOOM_LEVEL = 0.5
const MIN_ZOOM_LEVEL = 4.0
const ZOOM_INCREMENT = 0.05
signal moved()
signal zoomed
var focused = false
var old_pos
var _current_zoom_level = 1
var _drag = false
var save_pos
var ui
func _input(event):
	if !focused:
			
		if event.is_action_pressed("move_map"):
			_drag = true
		elif event.is_action_released("move_map"):
			save_pos = event.global_position
			_drag = false
		elif event is InputEventMouseMotion && _drag:
			print(event.relative)
			arrive_to(position - (event.relative *10))
			emit_signal("moved")
	if event.is_action("scroll_up"):
		_update_zoom(-ZOOM_INCREMENT, get_global_mouse_position())
	if event.is_action("scroll_down"):
		_update_zoom(ZOOM_INCREMENT, get_global_mouse_position())
		
		
func _update_zoom(incr, zoom_anchor):
	
	
		var old_zoom = _current_zoom_level
		_current_zoom_level += incr
		if _current_zoom_level < MAX_ZOOM_LEVEL:
			_current_zoom_level = MAX_ZOOM_LEVEL
		elif _current_zoom_level > MIN_ZOOM_LEVEL:
			_current_zoom_level = MIN_ZOOM_LEVEL
		if old_zoom == _current_zoom_level:
			return
		_target_zoom = _current_zoom_level
		
		
#		var zoom_center = zoom_anchor - get_offset()
#		var ratio = 1-_current_zoom_level/old_zoom
#		set_offset(get_offset() + zoom_center*ratio)
		
#		set_zoom(Vector2(_current_zoom_level, _current_zoom_level))
		emit_signal("zoomed")










# Distance to the target in pixels below which the camera slows down.
const SLOW_RADIUS := 300.0

# Maximum speed in pixels per second.
export var max_speed := 2000.0
# Mass to slow down the camera's movement
export var mass := 2.0

var _velocity = Vector2.ZERO
# Global position of an anchor area. If it's equal to `Vector2.ZERO`,
# the camera doesn't have an anchor point and follows its owner.
var _anchor_position = Vector2.ZERO
var _target_zoom := 1.0
func _ready() -> void:
	# Setting a node as top-level makes it move independently of its parent.
	set_as_toplevel(true)
	SignalBus.connect("anchor_detected", self, "_on_AnchorDetector2D_anchor_detected")
	SignalBus.connect("anchor_detached", self, "_on_AnchorDetector2D_anchor_detached")


# Every frame, we update the camera's zoom level and position.
func _physics_process(delta: float) -> void:
#	if focused:
	update_zoom()

	# The camera's target position can either be `_anchor_position` if the value isn't
	# `Vector2.ZERO` or the owner's position. The owner is the root node of the scene in which we
	# instanced and saved the camera. In our demo, it's the Player.
	if focused:
		var target_position: Vector2 = (
			_anchor_position
			if not _anchor_position is KinematicBody2D
			else _anchor_position.get_global_position()
		)
		arrive_to(target_position)


# Entering in an `Anchor2D` we receive the anchor object and change our `_anchor_position` and
# `_target_zoom`
func _on_AnchorDetector2D_anchor_detected(anchor) -> void:
	focused = true
	ui = anchor.ui
	get_parent().get_node("CanvasLayer").add_child(ui)
	_anchor_position = anchor.global_position
	_target_zoom = anchor.zoom_level
	set_offset(Vector2.ZERO)
	
	
	


# Leaving the anchor the zoom return to 1.0 and the camera's center to the player
func _on_AnchorDetector2D_anchor_detached() -> void:
	ui.queue_free()
	print("detached")
	_target_zoom = 1.0
	_current_zoom_level = _target_zoom
	_anchor_position = _anchor_position.get_global_position()
	
	focused = false


# Smoothly update the zoom level using a linear interpolation.
func update_zoom() -> void:
	if not is_equal_approx(zoom.x, _target_zoom):
		# The weight we use considers the delta value to make the animation frame-rate independent.
		var new_zoom_level: float = lerp(
			zoom.x, _target_zoom, 1.0 - pow(0.008, get_physics_process_delta_time())
		)
		zoom = Vector2(new_zoom_level, new_zoom_level)
		


# Gradually steers the camera to the `target_position` using the arrive steering behavior.
func arrive_to(target_position: Vector2) -> void:
	var distance_to_target := position.distance_to(target_position)
	# We approach the `target_position` at maximum speed, taking the zoom into account, until we
	# get close to the target point.
	var desired_velocity := (target_position - position).normalized() * max_speed * zoom.x
	# If we're close enough to the target, we gradually slow down the camera.
	if distance_to_target < SLOW_RADIUS * zoom.x:
		desired_velocity *= (distance_to_target / (SLOW_RADIUS * zoom.x))

	_velocity += (desired_velocity - _velocity) / mass
	position += _velocity * get_physics_process_delta_time()







