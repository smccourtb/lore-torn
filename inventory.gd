extends Resource
class_name Inventory

signal items_changed(indexes)

export(Array, Resource) var items = []
var max_slots: int

func _init(size) -> void:
	
	self.max_slots = size
	for _i in range(max_slots):
		self.items.append(null)
	
func set_item(item_index, item):
#	if item:
#		print('made it this far: ', item.name, item_index)
#	var previousItem = items[item_index]
#	if !item:
#		print('got swooped up in the null')
#		items[item_index] = item
#	elif previousItem and previousItem.name == item.name:
#		items[item_index] = previousItem
#		previousItem.amount += item.amount
#	else:
	items[item_index] = item
	emit_signal('items_changed', [item_index])

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal('items_changed', [item_index])
	return previousItem

#func make_items_unique():
#	var unique_items = []
#	for item in items:
#		if item is Weapon:
#			unique_items.append(item)
#		elif item is Item:
#			unique_items.append(item.duplicate())
#		else:
#			unique_items.append(null)
#	items = unique_items

func add_item(new_item):
	var new_index: int
	for item in items:
		if item != null and new_item.name == item.name: #and !item.unique: # (new_item is Collectable) and 
			new_index = items.find(item)
#			item.amount += new_item.amount
			emit_signal('items_changed', [new_index])
	
		else:
			new_index = self.items.find(null , 0)
			self.set_item(new_index, new_item)
			emit_signal('items_changed', [new_index])
	return new_index
