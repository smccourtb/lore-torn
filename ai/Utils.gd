extends Node
class_name Utils


static func map_value(value, min_value : float, max_value : float) -> float:
	var map = (value - min_value) / (max_value - min_value)
	return clamp(map, 0.0, 1.0)
