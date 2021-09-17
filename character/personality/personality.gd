extends Resource
class_name Personality

var facets: Dictionary
var beliefs: Dictionary
var goals: Dictionary

func _init() -> void:
    facets = determine_traits()
    beliefs = determine_beliefs()

func determine_traits() -> Dictionary:
    var _traits: = {}
    var traits_list: Array = ['vanity', 'humor']
    for i in traits_list:
        var x = load("res://character/personality/facets/" + i + ".tres")
        var t = Facet.new(x)
        var value = Util.weighted_random(100, 5)
        _traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
    return _traits

func determine_beliefs():
    var _traits: = {}
    var traits_list: Array = ['family']
    for i in traits_list:
        var x = load("res://character/personality/beliefs/" + i + ".tres")
        var t = Belief.new(x)
        var value = Util.weighted_random(100, 5)
        _traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
    return _traits

func determine_goals():
    pass