extends Resource
class_name EmotionController

var emotions: Dictionary 
var primary_emotion: Emotion

func _init(profile: Array):
	generate_emotions(profile)
	
func update_primary_emotion() -> void:
	# trigger a possible interactions check
	var highest_level: int
	var name: Emotion
	for i in emotions.values():
		if !highest_level:
			highest_level = i.level
			name = i
		if i.level > highest_level:
			highest_level = i.level
			name = i
	primary_emotion = name

func get_primary_emotion() -> Emotion:
	return primary_emotion

func generate_emotions(emotion_list: Array):
	for i in emotion_list:
		var new_emotion: Emotion = Emotion.new(i)
		emotions[i.id] = new_emotion

func modify_emotion_level(emotion_id: int, amount: int):
	emotions[emotion_id].level += amount

func cycle():
	update_primary_emotion()
