extends KinematicBody2D
class_name Collectable

# Distance to pickup collectable
const COLLECT_RADIUS = 6.0
# Max distance this can be collected
const MAX_PICKUP_RADIUS = 2 * 24.0
# Max and min speed for randomized spawning
const SPEED_MIN = 3 * 24
const SPEED_MAX = 4 * 24
# Max distance to throw item vertically when spawning
const SPAWN_HEIGHT = 2
# Max speed to move when collecting
const SPEED = 6 * 24
# Frequency of sprite oscillation
const FLOAT_SPEED = 2.0
# How far to oscillate sprite
const FLOAT_DISTANCE = .75

onready var sprite = $Sprite
# Timer to delay pickup to allow them a moment to spawn and the player to see them

var title
var new_item
var velocity := Vector2()
var follower_path = ""
# Angle to oscillate sprite up and down via sin
var offset = 0


func _ready():
	# Randomize hover offset
#	offset = rand_range(-PI * 0.5, 0)
## warning-ignore:shadowed_variable
#	var offset = sin(offset * FLOAT_SPEED * PI) * FLOAT_DISTANCE - FLOAT_DISTANCE - 3
#	sprite.position.y = offset
	item_check()


#func _process(delta):
	# Animate sprite up and down
#	if !gravity_tween.is_active():
#		offset += delta * PI
## warning-ignore:shadowed_variable
#		var offset = sin(offset * FLOAT_SPEED * PI) * FLOAT_DISTANCE - FLOAT_DISTANCE - 3
#		sprite.position.y = offset


func _physics_process(delta):
	var follower = get_node_or_null(follower_path) if follower_path != "" else null
	
	if follower == null:
		# Stop slower if being thrown from spawn
		var weight = .7 #if gravity_tween.is_active() else 0.2
		# Apply stop velocity
		velocity = velocity.linear_interpolate(Vector2.ZERO, weight)
		# Unset the follower path so we don't bother checking for them anymore
		follower_path = ""
	else:
		# Vector towards where we want to go
		var displacement = follower.global_position - global_position
		var distance = displacement.length()
		# If we're close enough to be collected, then do so
		if distance < COLLECT_RADIUS:
				_on_pickup()
			
			
		# Else move towards the follower
		else:
			# Amount to modify the speed by based on distance from follower
			var factor = 1 - min(distance / MAX_PICKUP_RADIUS, 1.0)
			# If factor == 0 then collector is too far away
			if factor == 0:
				follower_path = ""
			var desired_velocity = displacement.normalized() * SPEED * factor
			desired_velocity = desired_velocity.clamped(distance / delta)
			velocity = velocity.linear_interpolate(desired_velocity, 1.0)
	
	var collision = move_and_collide(velocity * delta)
	# Bounce off of walls
	if collision:
		velocity = velocity.bounce(collision.normal)
	# If we're not following anything and we're stopped (with epsilon for precision reasons)
	if follower == null && velocity.length() < 0.2:
		velocity = Vector2.ZERO
		set_physics_process(false)


#func collect(collector):
#	# NOTE: is_physics_process() should prevent multiple things from trying to 
#	#		collect but has not been confirmed through testing
#	if collector == null || is_physics_processing() \
#			|| !pickup_delay_timer.is_stopped():
#		return
#
#	follower_path = get_path_to(collector)
#	set_physics_process(true)
#	var yerp = false
#	for item in inventory.items:
#		if item:
##			print('COLLECTABLE: ', new_item.name)
##			print('ITEM IN INVENTORY: ', item.name)
#			if item is Item and new_item.name.replace('_', ' ').capitalize() == item.name and !item.unique:
#					var new_index = inventory.items.find(item)
#					new_item.amount += item.amount
#					inventory.set_item(new_index, new_item)
#					$AudioStreamPlayer2D.pitch_scale = rand_range(.75, 1.25)
#					$AudioStreamPlayer2D.playing = true
#					yerp = true
#					break
#	# Create the reference of the item to add to inventory
#	var emptySlot = inventory.items.find(null , 0)
#	if !yerp:
#		if emptySlot != -1:
#
#			inventory.set_item(emptySlot, new_item)
#			# Play the collectable 'pop' sound
#			$AudioStreamPlayer2D.pitch_scale = rand_range(.75, 1.25)
#			$AudioStreamPlayer2D.playing = true
#		else:
#			set_physics_process(false)


func _on_pickup():
	queue_free()

func get_object_type():
	return new_item.type

# warning-ignore:unused_argument
func spawn(at : Vector2, angle : float, delay_duration = -1, \
		spawn_speed = rand_range(SPEED_MIN, SPEED_MAX)):
	global_position = at
	velocity = polar2cartesian(spawn_speed, angle)
	if Global.items.has(new_item.type):
		Global.items[new_item.type].append(self)
	else:
		Global.items[new_item.type] = [self]


func item_check():
	if new_item == null:
		new_item = load("res://resource/items/" + Util.filenameify(title) + ".tres").duplicate()
