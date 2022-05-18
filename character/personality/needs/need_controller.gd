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
		new_need.connect("first_threshold", self, "_on_Early_warning")
		self.needs[new_need.id] = new_need
	
func generate_need(resource: NeedTemplate) -> Need:
	return Need.new(resource)

func cycle():
	for i in needs.values():
		i.decrease_level(.05) # .0069 <- even throughut 24h

func _on_Early_warning(need_id):
	SignalBus.emit_signal("create_feeling", need_id)

