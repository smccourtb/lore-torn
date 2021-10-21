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
#		if check_if_available_materials(i):
#			button.disabled = false
#		else:
#			button.disabled = true
		button.connect("pressed", self, "_on_Button_pressed", [i, workstation_ref])
		
func _on_Button_pressed(project, ref) -> void:
	var workstation = Global.workstation_orders[project.workstation].has(ref)
	if workstation:
		Global.workstation_orders[project.workstation][ref].append(project)
	else:
		Global.workstation_orders[project.workstation][ref] = [project]
	queue_free()
	
	
func check_if_available_materials(project):
	var material_pos: = {}
	var item_pos = []
	var total_need: int = 0
	# loop through need materials
	
	for i in project.materials.keys():
		total_need += project.materials[i]
		# loop through stockpiles
		for j in Global.stockpiles:
			# check stockpile item list
			for k in j.items:
				if k !=null and k.get_object_type() == i:
					print("Found at ", k.position)
					if !material_pos.has(i):
						material_pos[i] = [k]
					else:
						if material_pos[i].size() < project.materials[i]:
							material_pos[i].append(k)
	var total_found: int = 0
	for i in material_pos.keys():
		total_found += material_pos[i].size()
		if material_pos[i].size() > 0:
			for j in material_pos[i]:
				item_pos.append(j.position)
	if total_need == total_found:
		material_positions = item_pos
		return true
	material_positions = null
	return false
		
func check_for_available_materials(project):
	var material_list = project.materials
	var item_to_search: String
	# material_list is a dictionary that has the items type as its key and its
	# its value is either an empty list or a list of all allowable subtypes
	for mat in material_list:
		var type = mat.values()[0]
		var subtype = mat.values()[1]
		if subtype.empty():
			item_to_search = type
		var item = 	null
		
