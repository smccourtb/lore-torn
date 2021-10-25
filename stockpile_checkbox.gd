extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var unactive: StyleBoxTexture
var active: StyleBoxTexture
var current: StyleBoxTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unactive = self.get_stylebox("normal")
	active = self.get_stylebox("pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressed:
		current = active
	else:
		current = unactive
	if is_hovered():
		self.add_stylebox_override("hover", current)
