extends Control


var available_projects: Array
var material_positions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_menu()

func setup_menu():
	for i in available_projects:
		var button = Button.new()
		button.text = i.name
		
		$Panel.add_child(button)
		if check_if_available_materials(i):
			button.disabled = false
		else:
			button.disabled = true
		button.connect("pressed", self, "_on_Button_pressed", [button.text, i])
		
func _on_Button_pressed(title, project) -> void:
	if Global.workstation_orders.has(project.workstation):
		Global.workstation_orders[project.workstation].append(project)
	else:
		Global.workstation_orders[project.workstation] = [project]
	queue_free()
	
	
func check_if_available_materials(project):
	var material_pos: = {}
	var item_pos = []
	var total_need: int
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
	var total_found: int
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
		
