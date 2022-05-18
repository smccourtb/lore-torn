extends Resource
class_name FeelingTemplate

export var id: int
export var title: String
# in hours
export var time: int
export var emotion_granted: Resource
export var emotion_points: int

export var chained_feeling: Resource
export var need_modifier: Dictionary
export var skill_modifier: Dictionary



# can last for a certain amount of time
# can have an effect after timer expires (increases to next stage)
# causes an emotion with a certain amount of points
# can improve skill gain
# if no time specified, last until condition is met to remove
