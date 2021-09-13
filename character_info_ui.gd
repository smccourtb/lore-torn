extends Control


onready var character_data = get_parent().get_node("TestRandomName").character_data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("CharacterInfoUI is ready")
	print(character_data.character_data())
	$Label.text = character_data.character_data().name
	var father = Button.new()
	father.text = "Father"
	father.margin_left = 100.00
	add_child(father)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
