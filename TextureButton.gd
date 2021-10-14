extends MenuButton


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_popup().set_exclusive(true)
	get_popup().add_check_item("all")
	get_popup().add_check_item("oak")
	get_popup().add_check_item("birch")
	get_popup().add_check_item("willow")
	get_popup().add_check_item("pine")
	get_popup().connect("id_pressed", self, "_on_item_pressed")
	get_popup().set_hide_on_checkable_item_selection(false)


func _on_item_pressed(id):
	print(id)
	get_popup().toggle_item_checked(get_popup().get_item_index(id))
