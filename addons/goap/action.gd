extends Resource
class_name Action

export var name: String 
export(String) var action = null
export(String) var preconditions = ""
export(String) var effect = ""
export(float) var cost = 1

func tostring() -> String:
	return name +"("+preconditions.tostring()+", "+effect.tostring()+", "+str(cost)+")"

func _init(n, p, e, c) ->void:
		name = n
		preconditions = p
		effect = e
		cost = c
