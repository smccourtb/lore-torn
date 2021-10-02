extends VBoxContainer

var character_name: String
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var column_size: int
var ref: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label.text = character_name
	$HBoxContainer/Label.rect_min_size = Vector2(column_size, 0)
	for i in Global.jobs.size():
		var checkbox = CheckBox.new()
		$HBoxContainer.add_child(checkbox)
		checkbox.connect("pressed", self, "_on_Pressed", [i, checkbox, ref])
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _on_Pressed(yo, boop, beep):
	print(character_name)
	print(boop.pressed)
	if boop.pressed:
		beep.assign_new_job(Global.jobs[yo])
	else:
		beep.remove_assigned_job(Global.jobs[yo])
