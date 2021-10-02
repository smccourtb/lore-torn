extends Resource
class_name AIContext

const SIZE = 16
const ANGLE_MULTIPLIER = 2 * PI / SIZE # Doesn't consider dynamic sizing

# Array storing which direction is desirable / undesirable for character
var weights := []
# How much to modify weight when getting values externally
var factor := 1.0

func _init():
	weights.resize(SIZE)
	for i in size():
		weights[i] = 0

func set_weight(index : int, value : float):
	if index >= 0 && index < size():
		weights[index] = value

func get_weight(index : int) -> float:
	if index >= 0 && index < size():
		return weights[index] * factor
	else:
		return -INF

func get_desired_direction() -> Vector2:
	return get_normal(get_max_index())

func get_normal(index : int) -> Vector2:
	if index >= 0 && index < size():
		return polar2cartesian(1.0, get_angle(index))
	else:
		return Vector2.ZERO

# Used to combine all weights into a single weight once calculations are done
func combine(contexts : Array):
	for i in size():
		weights[i] = 0.0
		for context in contexts:
			weights[i] += context.get_weight(i)

# Returns the array index that contains the highest weight above a given value
func get_max_index(min_weight := 0.0) -> int:
	var idx = -1
	var max_weight = min_weight
	for i in size():
		var weight = get_weight(i)
		if weight > max_weight:
			max_weight = weight
			idx = i
	return idx

# Sets all values to 0, used for recycling context
func clear():
	for i in size():
		weights[i] = 0.0

func get_angle(index : int):
	return ANGLE_MULTIPLIER * index

func size() -> int:
	return weights.size() #if using dynamic sizing  #SIZE

func _to_string():
	return str(weights)
