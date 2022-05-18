extends Resource
class_name FeelingController
# a dictionary of all feelings with the {key: feeling id / value: feeling_resource}
var feelings_resources = preload("res://character/personality/feeling/feelings.tres")
var active_feelings: Dictionary
signal feeling_created(feeling)
signal feeling_removed(feeling)
# TODO: implement stage 2 / stage 3

func _init():
	SignalBus.connect("updated", self, "_on_time_updated")
	SignalBus.connect("create_feeling", self, "create_feeling")
	
	
func create_feeling(feeling_id: int) -> void:
	if not active_feelings.has(feeling_id):
		var resource: FeelingTemplate = feelings_resources.resources[feeling_id]
		var new_feeling: Feeling = Feeling.new(resource)
		active_feelings[feeling_id] = new_feeling
		emit_signal("feeling_created", active_feelings[feeling_id])
		new_feeling.connect("remove_feeling", self, "_on_remove_feeling")
		
		# Apply emotional updates

func _on_time_updated(value):
	cycle()

func cycle():
	for i in active_feelings.values():
		i.update_duration()

func _on_remove_feeling(feeling: Feeling):
	active_feelings.erase(feeling.id)
	emit_signal("feeling_removed", feeling)

