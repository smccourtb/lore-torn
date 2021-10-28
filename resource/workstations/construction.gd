extends StaticBody2D
class_name Construction

var id: int
var data: Resource

var materials: Dictionary
var status: bool = false  # is built or not



func build():
	status = true
	($Sprite as Sprite).set_modulate(Color(1,1,1,1))
