extends Resource
class_name NeedController

var needs_resources: Array
var needs: Dictionary

func _init(needs_profile:Array):
	set_resources(needs_profile)
	generate_profile()
	
func set_resources(profile: Array):
	self.needs_resources = profile

func generate_profile():
	for i in needs_resources:
		var new_need: Need = generate_need(i)
		new_need.connect("threshold_triggered", self, "_on_need_threshold_reached")
		self.needs[new_need.id] = new_need
	
func generate_need(resource: NeedTemplate) -> Need:
	return Need.new(resource)

func cycle():
	for i in needs.values():
		i.decrease_level(3) # .0069 <- even throughout 24h

func _on_need_threshold_reached(feeling_id: int):
	SignalBus.emit_signal("create_feeling", feeling_id)

