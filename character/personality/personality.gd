extends Resource
class_name Personality

var traits: Dictionary
var beliefs: Dictionary
var goals: Dictionary

func _init() -> void:
    traits = determine_personality_traits()

func determine_personality_traits() -> Dictionary:
    var _traits: = {}
    var traits_list: Array = ['vanity', 'humor']
    for i in traits_list:
        var x = load("res://character/personality/traits/" + i + ".tres")
        var t = Trait.new(x)
        var value = Util.weighted_random(100, 5)
        _traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
    return _traits

func determine_beliefs():
    pass

func determine_goals():
    pass