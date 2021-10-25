extends Control


var available_projects: Array
var material_positions
var workstation_ref: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_menu()

func setup_menu():
	for i in available_projects:
		var button = Button.new()
		button.text = i.name
		
		$Panel.add_child(button)
		if check_for_available_materials(i):
			button.disabled = false
		else:
			button.disabled = true
		button.connect("pressed", self, "_on_Button_pressed", [i, workstation_ref])
		
func _on_Button_pressed(project, ref) -> void:
	var workstation = Global.workstation_orders[project.workstation].has(ref)
	if workstation:
		Global.workstation_orders[project.workstation][ref].append(project)
	else:
		Global.workstation_orders[project.workstation][ref] = [project]
	queue_free()

func check_for_available_materials(project) -> bool:
	var material_list: Array = project.materials.duplicate()
	for mat in project.materials:
		var type = mat.keys()[0]
		var subtype = mat.values()[0]
		if subtype.empty():
			subtype = ""
		else:
			subtype = subtype[0]
		for stockpile in Global.stockpiles:
			if stockpile.check_for_item(type, subtype):
				material_list.erase(mat)
				if material_list.empty():
					return true
	return false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
					queue_free()
