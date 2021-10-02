extends Resource
class_name AIMovement

const UPDATE_DURATION = 0.0 #1.0 / 20

# Used to move to a position
var seek := AIContext.new()
# Used to sidestep around a position
var strafe := AIContext.new()
# Used to maintain a consistent direction against minor changes
var bias := AIContext.new()
# Used to push away from nearby characters
var separation := AIContext.new()
# Used to avoid minor obstacles
var collision := AIContext.new()

var weights := AIContext.new()

# Must be a character, but can't assign due to cyclic dependancy
var actor : KinematicBody2D

func _init(_actor):
	actor = _actor

func get_pursue_velocity(target_position : Vector2, \
		arrival_distance := 32.0, arrival_deadzone := 12.0) -> Vector2:
	# Vector pointing from actor toward target
	var displacement = target_position - actor.global_position
	var distance = displacement.length()
	
	# update context information
	seek = _get_direction_context(displacement, seek)
	strafe = _get_strafe_context(displacement)
	bias = _get_direction_context(actor.velocity.normalized(), bias)
	separation = _get_separation_context(actor.get_neighbors())
	collision = _get_collision_context()
	
	seek.factor = 1.0
	if arrival_distance - arrival_deadzone != 0:
		# Weight towards target, less so closer to the target
		seek.factor = Utils.map_value(distance, arrival_deadzone, arrival_distance)
	 # Strafe around the target if nearby
	strafe.factor = 1.0 - seek.factor
	# Just small enough to influence their direction
	bias.factor = 0.05
	
	weights.combine([seek, strafe, bias, separation, collision])
	
	return weights.get_desired_direction() * actor.get_move_speed()

# Takes a normal and applies weights to a context array in the direction of the normal
func _get_direction_context(displacement : Vector2, context := AIContext.new()) -> AIContext:
	# If not trying to move, then clear context and return
	if displacement == Vector2.ZERO:
		context.clear()
		return context
	
	for i in context.size():
		# Vector2 pointing in context direction
		var value = cos(displacement.angle() - context.get_angle(i))
		# Normalize between 0 and 1
		var weight = (value * 0.5 + 0.5)
		context.set_weight(i, weight)
	return context

func _get_strafe_context(displacement : Vector2) -> AIContext:
	for i in strafe.size():
		var value = cos(displacement.angle() - strafe.get_angle(i))
		# Shaping function
		var weight = 1.0 - abs(value + 0.05)
		strafe.set_weight(i, weight)
	return strafe

func _get_separation_context(entities = [], exceptions = [], \
		separation_distance := 32.0) -> AIContext:
	separation.clear()
	# Iterate through all neighbors and get Vector pointing away from them
	var away_vector := Vector2()
	var max_factor = 0.0
	# Generate a vector pointing away from the crowd
	for entity in entities:
		if entity == actor || exceptions.has(entity):
			continue
		
		# Get vector pointing away from entity
		var displacement = actor.global_position - entity.global_position
		var distance = displacement.length()
		if distance < separation_distance:
			# value 0 to 1 for how close to entity
			var factor = 1.0 - (distance / separation_distance)
			max_factor = max(factor, max_factor)
			# Add in normalized vector modified by factor
			away_vector += (displacement / distance) * factor
	
	# Once you have the away vector, use it to generate weights
	if away_vector != Vector2.ZERO:
		for i in separation.size():
			var value = cos(away_vector.angle() - separation.get_angle(i))
			var weight = 1.0 - abs(value - 0.65)
			separation.set_weight(i, weight * max_factor)
			
	return separation

# Iterates through a context array performing raycasts to determine
# which directions this entity can move towards
func _get_collision_context(collision_distance := 16.0) -> AIContext:
	for i in collision.size():
		var vel = polar2cartesian(collision_distance, collision.get_angle(i))
		var _origin = actor.global_position
		var _space_state = actor.get_world_2d().direct_space_state
		
		# If collision detected then entity can not move in this direction
		if actor.test_move(actor.global_transform, vel):
			# Setting to -INF will make this direction unusable
			collision.set_weight(i, -INF)
		else:
			# Reset to 0 since we're recycling the contexts
			collision.set_weight(i, 0)
	return collision
