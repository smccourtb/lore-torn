extends Resource
class_name PersonalityController

## ID STRUCTURE
#	NEEDS - 0 - 49
#	EMOTIONS: 50 - 99
#	FEELINGS: 100 - 1999
#	TRAITS: 2000 - 3999
# 	CHARACTERS: 4000 - 5999
#   OBJECTS: 6000 - 9999


var owner_ref: Resource
var need_controller: NeedController
var feeling_controller: FeelingController
var emotion_controller: EmotionController
var personality_trait_controller: PersonalityTraitController

const UPDATE_INTERVAL: float = .5

# fed by traits and emotions
var object_triggers: Array
var time_triggers: Dictionary = {}
var social_triggers: Array



func _init(profile: PersonalityTemplate, owner: Resource) -> void:
	owner_ref = owner
	SignalBus.connect("minute", self, "_on_time_update")
	SignalBus.connect("add_time_trigger", self, "_on_add_time_trigger")
	
	generate_personality(profile)




func generate_personality(profile: PersonalityTemplate):
	self.need_controller = NeedController.new(profile.needs)
	self.feeling_controller = FeelingController.new()
	self.emotion_controller = EmotionController.new(profile.emotions)
	self.personality_trait_controller = PersonalityTraitController.new(profile.personality_traits, self)
	feeling_controller.connect("feeling_created", self, "_on_feeling_created")
	feeling_controller.connect("feeling_removed", self, "_on_feeling_removed")


func _on_feeling_created(feeling: Feeling):
	emotion_controller.modify_emotion_level(feeling.emotion_granted.id, feeling.emotion_points)

func _on_feeling_removed(feeling: Feeling):
	emotion_controller.modify_emotion_level(feeling.emotion_granted.id, -feeling.emotion_points)


func _on_time_update(value: int):
	if time_triggers.has(value):
		personality_trait_controller.execute_trigger(time_triggers[value])
		if time_triggers[value].repeatable:
			personality_trait_controller.setup_time_triggers([time_triggers[value]])
		time_triggers.erase(value)

	self.need_controller.cycle()
	self.emotion_controller.cycle()


func _on_add_time_trigger(trigger: TimeTrigger):
	print("add time trigger called")
	var wait_time = Time.value + trigger.delay
	time_triggers[wait_time] = trigger
