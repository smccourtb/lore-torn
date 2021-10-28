extends Construction
class_name Workstation

var projects: Array
var workstation_name: String

func _ready() -> void:
	setup_node(data)
	
func setup_node(resource_data: WorkstationTemplate):
	($Sprite as Sprite).set_texture(resource_data.get_texture())
	projects = resource_data.project_options
	id = get_instance_id()
	
func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var menu: Control = load("res://ui/WorkstationInterface.tscn").instance()
		menu.available_projects = projects
		menu.workstation_ref = id
		add_child(menu)
