extends Resource
class_name State

var value
var mask

func _init(v, m):
	value = v
	mask = m

func equals(state) -> bool:
	return value == state.value and mask == state.mask

func check(condition) -> bool:
	return (condition.mask & mask) == condition.mask and (value & condition.mask) == condition.value

func apply(effect):
	return get_script().new((value & mask & (~effect.mask)) | (effect.value & effect.mask), mask | effect.mask)

func tostring() -> String:
	return "("+str(value)+", "+str(mask)+")"
