extends PersonalityTrait
class_name Belief


func _init(t) -> void:
	self.trait_name = t.name
	self.trait_descriptions = t.description