extends Resource
class_name Need

var title: String
var id: int
var description: String
var level: float
var min_threshold: int
var very_low_threshold: int
# holds the feelings ids
var feeling_effects: Array
var base_decay_rate: float = 0.05

signal first_threshold(feeling_modifier)


func _init(need_template: NeedTemplate):
	var need_resource: NeedTemplate = need_template.duplicate()
	set_title(need_resource.title)
	set_description(need_resource.description)
	set_level(100)
	self.min_threshold = 30
	self.very_low_threshold = 10
	self.feeling_effects = need_resource.feeling_effects
	self.id = need_resource.id


func get_title() -> String:
	return self.title

func set_title(new_title: String) -> void:
	self.title = new_title

func get_description() -> String:
	return self.description

func set_description(new_description) -> void:
	self.description = new_description

func get_level() -> float:
	return self.level

func set_level(new_level: float) -> void:
	self.level = new_level
	if get_level() <= self.min_threshold:
		first_threshold_hit()
		return

func decrease_level(amount: float) -> void:
	var current_level: float = get_level()
	set_level(current_level - amount)
	
func first_threshold_hit():
	if feeling_effects.size() > 0:
		emit_signal("first_threshold", feeling_effects[0])
