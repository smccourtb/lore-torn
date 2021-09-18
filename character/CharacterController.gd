extends Node2D

# contains all information of character
var data
var velocity: Vector2 = Vector2.ZERO
var speed: int
func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	position = position.move_toward(Vector2(500,500), delta * speed)

