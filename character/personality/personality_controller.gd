extends Node
class_name PersonalityController

## ID STRUCTURE
#	NEEDS - 0 - 49
#	EMOTIONS: 50 - 99
#	FEELINGS: 100 - 1999
# 	CHARACTERS: 2000 - 2499
#   OBJECTS: 2500 - 4999


# setup needs
# generate traits (3)
# generate inspiration
# generate inspiration trait
# setup emotions
# determine primary emotion
# determine possible social interactions

# ORDER OF ACTIONS
#	- physical needs (if mood level below a certain threshold)
#   - player orders ( if emotion permits)
#	- emotional needs
#	- whims

# new primary emotion is triggered
# sets up possible INTERACTONS (things you can talk about with another character)
# sets up possible ACTIVITIES (what it can and cant do, behavior tree stuff?)



# TRAITS
# set trait
# sets up possible INTERACTONS (things you can talk about with another character)
# 
var traits: Dictionary
var need_controller: NeedController
var feeling_controller: FeelingController
var emotion_controller: EmotionController

# feelings effect emotions

# fed by traits and emotions
var object_triggers: Array

var social_triggers: Array
var unlocked_interactions: Array

var timer: Timer

func _init(profile: PersonalityTemplate) -> void:
	generate_personality(profile)

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start(.5)
	

func generate_personality(profile: PersonalityTemplate):
	#generate personality_trait_controller()
	self.need_controller = NeedController.new(profile.needs)
	self.feeling_controller = FeelingController.new()
	self.emotion_controller = EmotionController.new(profile.emotions)
	feeling_controller.connect("feeling_created", self, "_on_feeling_created")
	feeling_controller.connect("feeling_removed", self, "_on_feeling_removed")
	


func _on_feeling_created(feeling: Feeling):
	print("Weelllll ehat do you know: ", feeling.title)
	emotion_controller.modify_emotion_level(feeling.emotion_granted.id, feeling.emotion_points)

func _on_feeling_removed(feeling: Feeling):
	emotion_controller.modify_emotion_level(feeling.emotion_granted.id, -feeling.emotion_points)
	

func _on_Timer_timeout() -> void:
	self.need_controller.cycle()
	self.emotion_controller.cycle()
