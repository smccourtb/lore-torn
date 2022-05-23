extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var furniture_node = load("res://resource/workstations/Furniture.tscn")
var generated_furniture: Furniture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func generate_furniture(w_name: String):
	var furniture = furniture_node.instance()
	furniture.setup_node(load_construction_data(w_name))
	furniture.get_node("Sprite").set_modulate(Color(1,1,1,.25))
	get_tree().get_root().get_node("Main").add_child(furniture)
	return furniture

func load_construction_data(w_name: String):
	var data = load("res://resource/furniture/" + w_name + ".tres")
	return data

func _on_Bed_pressed() -> void:
	generated_furniture = generate_furniture('bed')

func _process(_delta: float) -> void:
	if generated_furniture:
		generated_furniture.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if generated_furniture:
			generated_furniture.position = Global.map_grid.calculate_map_position(Global.map_grid.calculate_grid_coordinates(get_global_mouse_position()))
			Global.pending_constructions.append(generated_furniture)
			Global.workstation_position = generated_furniture.position
			generated_furniture = null
#			SignalBus.emit_signal("workstation_built")
	if event is InputEventKey and event.is_pressed():
		if event.get_scancode() == KEY_ESCAPE:
			if generated_furniture:
				generated_furniture.queue_free()
			queue_free()
