extends Resource
class_name Need

var title: String
var id: int
var description: String
var level: float
# holds the feelings ids in the order they are called
var feeling_effects: Array
var trigger_thresholds = [30, 10]
var base_decay_rate: float = 0.05
var first_effect_was_triggered: bool = false
var current_decay_rate: float

signal threshold_triggered(feeling_id)
signal need_changed(value)


func _init(need_template: NeedTemplate):
	var need_resource: NeedTemplate = need_template.duplicate()
	set_title(need_resource.title)
	set_description(need_resource.description)
	set_level(100)
	self.feeling_effects = need_resource.feeling_effects
	self.id = need_resource.id
	current_decay_rate = need_resource.base_decay_rate


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
	if new_level <= 0:
		new_level = 0
	self.level = new_level
	emit_signal("need_changed", get_level())
	check_for_threshold_triggers()

func decrease_level(amount: float) -> void:
	var current_level: float = get_level()
	set_level(current_level - amount)
	
func threshold_triggered(feeling_id: int):
	emit_signal("threshold_triggered", feeling_id)


func check_for_threshold_triggers():
	var current_level = get_level()
	if feeling_effects.size() < 1:
		return 
	if current_level > trigger_thresholds[0]: # IDEA: maybe add 10 or 15 to create a buffer so you have to get over it to have the negative modifer apply again
		first_effect_was_triggered = false
		return
	for triggers in range(trigger_thresholds.size()):
		if current_level <= trigger_thresholds[triggers]:
			if triggers != 0 or not first_effect_was_triggered:
				threshold_triggered(feeling_effects[triggers])
			first_effect_was_triggered = true
			
			
