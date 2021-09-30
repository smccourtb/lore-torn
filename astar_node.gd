extends Resource
class_name AStarNode
	
var state
var previous
var last_action
var cost

func _init(s, p, la, c):
	state = s
	previous = p
	last_action = la
	cost = c
