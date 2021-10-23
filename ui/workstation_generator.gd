extends Control


const CARPENTERS_WORKBENCH = "res://assets/props/carpenters_workbench.tres"

var workstation_node = load("res://resource/workstations/Workstation.tscn")
var generated_workstation: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func generate_workstation(w_name: String):
	var workstation = workstation_node.instance()
	workstation.data = load_workstation_data(w_name)
	workstation.get_node("Sprite").set_modulate(Color(1,1,1,.25))
	get_tree().get_root().add_child(workstation)
	return workstation
	
func load_workstation_data(w_name):
	var data = load("res://assets/props/" + w_name + ".tres")
	return data


func _on_Carpenters_Workbench_pressed() -> void:
	generated_workstation = generate_workstation("carpenters_workbench")

func _process(_delta: float) -> void:
	if generated_workstation:
		generated_workstation.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if generated_workstation:
			generated_workstation.position = Global.map_grid.calculate_map_position(Global.map_grid.calculate_grid_coordinates(get_global_mouse_position()))
			Global.pending_constructions.append(generated_workstation)
			Global.workstation_position = generated_workstation.position
			generated_workstation = null
#			SignalBus.emit_signal("workstation_built")
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			if generated_workstation:
				generated_workstation.queue_free()
			queue_free()
		
