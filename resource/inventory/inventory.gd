extends Resource
class_name Inventory

signal items_changed(indexes)

export(Array) var items = []
var max_slots: int

func _init(size) -> void:
	self.max_slots = size
	self.items = []
	for _i in range(max_slots):
		self.items.append(null)
	
func set_item(item_index, item) -> void:
	items[item_index] = item
	emit_signal('items_changed', [item_index])

func remove_item(item_index) -> Item:
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal('items_changed', [item_index])
	return previousItem

func add_item(new_item) -> int:
	var new_index: int
	new_index = self.items.find(null , 0)
	self.set_item(new_index, new_item)
	emit_signal('items_changed', [new_index])
	return new_index

func get_item_index(type: String, subtype: String = "") -> int:
	var index: int = 0
	for i in items:
		if subtype:
			if i.subtype == subtype:
				return index
		if i.type == type:
			return index
		index += 1
	return -1

func check_if_full() -> bool:
	var check_null = self.items.find(null , 0)
	if check_null < 0:
		return true
	return false
