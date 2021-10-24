extends Resource
class_name Inventory

signal items_changed(indexes)

export(Array) var items = []
var max_slots: int

func _init(size) -> void:
	self.max_slots = size
	# make sure items is empty
	self.items = []
	# fill inventory slots with null as placeholders
	for _i in range(max_slots):
		self.items.append(null)
	
func set_item(item_index: int, item: Item) -> void:
	items[item_index] = item
	emit_signal('items_changed', [item_index])

func remove_item(item_index) -> Item:
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal('items_changed', [item_index])
	return previousItem

func add_item(new_item) -> int:
	var new_index: int = self.find_empty_slot()
	if new_index != -1:
		self.set_item(new_index, new_item)
		emit_signal('items_changed', [new_index])
	return new_index

func get_item_index(type: String, subtype: String = "") -> int:
	var index: int = 0
	for i in items:
		if subtype:
			if i.get_object_subtype() == subtype:
				return index
		if i.get_object_type() == type:
			return index
		index += 1
	return -1

func get_items() -> Array:
	var item_list := []
	for i in items.size():
		if items[i]:
			var type: String = items[i].get_object_type()
			var subtype: String = items[i].get_object_subtype()
			var id: int = items[i].get_id()
			item_list.append({"type":type, "subtype": subtype, "index": i, "id": id})
	return item_list

func find_empty_slot() -> int: # if -1 then items is full
	return self.items.find(null , 0)

func check_for_item(item_type: String, item_subtype: String = "") -> Dictionary:
	var item_list: Array = get_items()
	for item in item_list:
		if !item_subtype:
			if item.type == item_type:
				return item
		else:
			if item.type == item_type and item.subtype == item_subtype:
				return item
	return {}
