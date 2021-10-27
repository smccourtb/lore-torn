extends StaticBody2D
class_name Workstation

var id: int
var data: Resource
var projects: Array
var materials: Dictionary
var workstation_name: String
var status: bool = false  # is built or not
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_node(data)

func setup_node(resource_data: WorkstationTemplate):
	($Sprite as Sprite).set_texture(resource_data.get_texture())
	projects = resource_data.project_options
	id = get_instance_id()

func build():
	status = true
	($Sprite as Sprite).set_modulate(Color(1,1,1,1))

func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var menu: Control = load("res://ui/WorkstationInterface.tscn").instance()
		menu.available_projects = projects
		menu.workstation_ref = id
		add_child(menu)
		
