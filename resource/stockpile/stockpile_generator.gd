extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_Wood_pressed() -> void:
	create_stockpile("wood", [])


func _on_Minerals_pressed() -> void:
	create_stockpile("mineral", [])


func _on_Plants_pressed() -> void:
	create_stockpile("plants", [])


func _on_Furniture_pressed() -> void:
	create_stockpile("furniture", [])


func _on_Food_pressed() -> void:
	create_stockpile("food", [])

func create_stockpile(item_type: String, item_subtypes: Array):
	var zone_selector = load("res://resource/stockpile/ZoneGenerator.tscn").instance()
	get_tree().get_root().add_child(zone_selector)
	zone_selector.item = {item_type: item_subtypes}
	zone_selector.type = "stockpile"
