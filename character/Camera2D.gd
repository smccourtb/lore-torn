extends Camera2D


# Distance to the target in pixels below which the camera slows down.
const SLOW_RADIUS := 300.0

# Maximum speed in pixels per second.
export var max_speed := 2000.0
# Mass to slow down the camera's movement
export var mass := 2.0

var _velocity = Vector2.ZERO
# Global position of an anchor area. If it's equal to `Vector2.ZERO`,
# the camera doesn't have an anchor point and follows its owner.
var _anchor_position := Vector2.ZERO
var _target_zoom := 1.0
var focused = true
func _ready() -> void:
	# Setting a node as top-level makes it move independently of its parent.
	set_as_toplevel(true)
	SignalBus.connect("anchor_detected", self, "_on_AnchorDetector2D_anchor_detected")


# Every frame, we update the camera's zoom level and position.
func _physics_process(delta: float) -> void:
	if focused:
		update_zoom()

		# The camera's target position can either be `_anchor_position` if the value isn't
		# `Vector2.ZERO` or the owner's position. The owner is the root node of the scene in which we
		# instanced and saved the camera. In our demo, it's the Player.
		var target_position: Vector2 = (
			_anchor_position
			if _anchor_position.is_equal_approx(Vector2.ZERO)
			else _anchor_position
		)

		arrive_to(_anchor_position)


# Entering in an `Anchor2D` we receive the anchor object and change our `_anchor_position` and
# `_target_zoom`
func _on_AnchorDetector2D_anchor_detected(anchor) -> void:
	current = !current
	print("Recieved")
	_anchor_position = anchor.global_position.global_position
	_target_zoom = anchor.zoom_level


# Leaving the anchor the zoom return to 1.0 and the camera's center to the player
func _on_AnchorDetector2D_anchor_detached() -> void:
	_anchor_position = Vector2.ZERO
	_target_zoom = 1.0
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
