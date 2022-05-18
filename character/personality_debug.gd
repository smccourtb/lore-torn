extends Control


var character: CharacterController


var personality
var emotion: String
var emotion_level: String
var feelings
var emotions: Array

onready var timer = get_node("Timer")

# Emotions
onready var e1 = get_node("HB/VB/E1")
onready var e1_value = get_node("HB/VB2/EV1")
onready var e2 = get_node("HB/VB/E2")
onready var e2_value = get_node("HB/VB2/EV2")
onready var e3 = get_node("HB/VB/E3")
onready var e3_value = get_node("HB/VB2/EV3")
onready var e4 = get_node("HB/VB/E4")
onready var e4_value = get_node("HB/VB2/EV4")
onready var e5 = get_node("HB/VB/E5")
onready var e5_value = get_node("HB/VB2/EV5")
onready var e6 = get_node("HB/VB/E6")
onready var e6_value = get_node("HB/VB2/EV6")

# Feelings
onready var f_header =  get_node("HB/VB3")
onready var f_value =  get_node("HB/VB4")

# Needs
onready var n1 = get_node("HB/VB5/N1")
onready var n1_value = get_node("HB/VB6/NV1")
onready var n2 = get_node("HB/VB5/N2")
onready var n2_value = get_node("HB/VB6/NV2")
onready var n3 = get_node("HB/VB5/N3")
onready var n3_value = get_node("HB/VB6/NV3")
onready var n4 = get_node("HB/VB5/N4")
onready var n4_value = get_node("HB/VB6/NV4")
onready var n5 = get_node("HB/VB5/N5")
onready var n5_value = get_node("HB/VB6/NV5")
onready var n6 = get_node("HB/VB5/N6")
onready var n6_value = get_node("HB/VB6/NV6")


func _ready() -> void:
	yield(get_tree().create_timer(.01), "timeout")
	personality = character.data.personality
	emotions = personality.emotion_controller.emotions.values()
	feelings = personality.feeling_controller.active_feelings
	
	
func _process(delta: float) -> void:
	yield(get_tree().create_timer(.01), "timeout")
	
	# Emotions
	e1.text = String(emotions[0].title)
	e1_value.text = String(emotions[0].level)
	e2.text = String(emotions[1].title)
	e2_value.text = String(emotions[1].level)
	e3.text = String(emotions[2].title)
	e3_value.text = String(emotions[2].level)
	e4.text = String(emotions[3].title)
	e4_value.text = String(emotions[3].level)
	e5.text = String(emotions[4].title)
	e5_value.text = String(emotions[4].level)
	e6.text = String(emotions[5].title)
	e6_value.text = String(emotions[5].level)
	
	# Feelings
	
	
	feelings = personality.feeling_controller.active_feelings
	# Needs
	n1.text = personality.need_controller.needs[0].title
	n1_value.text = String(personality.need_controller.needs[0].level)
	n2.text = personality.need_controller.needs[1].title
	n2_value.text = String(personality.need_controller.needs[1].level)
	n3.text = personality.need_controller.needs[2].title
	n3_value.text = String(personality.need_controller.needs[2].level)
	n4.text = personality.need_controller.needs[3].title
	n4_value.text = String(personality.need_controller.needs[3].level)
	n5.text = personality.need_controller.needs[4].title
	n5_value.text = String(personality.need_controller.needs[4].level)
	n6.text = personality.need_controller.needs[5].title
	n6_value.text = String(personality.need_controller.needs[5].level)
	


func _on_Timer_timeout() -> void:
	for n in f_header.get_children():
		if n.name != "Header":
			f_header.remove_child(n)
			n.queue_free()
	for u in f_value.get_children():
		if u.name != "Header":
			f_value.remove_child(u)
			u.queue_free()
	for i in feelings.values():
			var label_title = Label.new()
			var label_value = Label.new()
			label_title.text = i.title
			label_value.text = String(i.time_left)
			f_header.add_child(label_title)
			f_value.add_child(label_value)
