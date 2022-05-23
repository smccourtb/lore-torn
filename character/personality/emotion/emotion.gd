extends Resource
class_name Emotion

var title: String
var id: int
var level: int
var current_stage: int
var stages: Array

func _init(emotion_template: EmotionTemplate, starting_level: int = 0):
	self.title = emotion_template.title
	self.stages = emotion_template.stages
	set_level(starting_level)
	set_current_stage()

func get_level() -> int:
	return self.level

func set_level(increase_by: int) -> void:
	self.level += increase_by
	set_current_stage()

func reset_level() -> void:
	set_level(-get_level())

func set_current_stage() -> void:
	var current_level: int = get_level()
	var stage: int
	for i in range(0, self.stages.size(), 1):
		if self.stages[i].has("threshold"):
			if current_level > self.stages[i].threshold:
				stage = i
	self.current_stage = stage

func get_current_stage() -> Dictionary:
	return self.stages[self.current_stage]
