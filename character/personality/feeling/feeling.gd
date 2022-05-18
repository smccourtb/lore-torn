extends Resource
class_name Feeling

var title: String
var id: int
# in hours
var duration: int
var emotion_granted: Resource
var emotion_points: int
var time_created: int
var time_left: int

var chained_feeling: Resource
var need_modifier: Dictionary
var skill_modifier: Dictionary

signal remove_feeling(feeling)

func _init(feeling_template: FeelingTemplate):
	var feeling_resource = feeling_template.duplicate()
	self.title = feeling_resource.title
	self.id = feeling_resource.id
	self.duration = feeling_resource.time
	self.time_left = feeling_resource.time
	self.emotion_granted = feeling_resource.emotion_granted
	self.emotion_points = feeling_resource.emotion_points
	self.chained_feeling = feeling_resource.chained_feeling
	self.need_modifier = feeling_resource.need_modifier
	self.skill_modifier = feeling_resource.skill_modifier
	self.time_created = Time.value
	
# used to set timer
func convert_time_to_minutes():
	var minutes = duration * 60
	return minutes

func update_duration():
	time_left -=1
	if Time.value >= (time_created + duration):
		print(title, " is about to wear off")
		emit_signal("remove_feeling", self)
