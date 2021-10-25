extends Control


var stockpile: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = $"Panel/HBoxContainer".get_children()
	for i in stockpile.allowed.keys():
		var path = "Panel/HBoxContainer/" + i.capitalize()
		var childs = get_node(path).get_children()
		for child in childs:
			if child is MarginContainer:
				var c = child.get_children()[0]
				
				c.get_children()[0].pressed = true

func _on_CheckBox_toggled(button_pressed: bool, type: String, subtype: String) -> void:
	print(type, subtype) # Replace with function body.
	if button_pressed:
		if stockpile.allowed.has(type):
			if not subtype in stockpile.allowed[type]:
				stockpile.allowed[type].append(subtype)
		else:
			stockpile.allowed[type] = [subtype]
	else:
		stockpile.allowed[type].erase(subtype)
		if stockpile.allowed[type].empty():
			stockpile.allowed.erase(type)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			queue_free()
