extends Resource
class_name Personality

var facets: Dictionary
var beliefs: Dictionary
var goals: Dictionary

func _init() -> void:
    facets = determine_facets()

func determine_facets() -> Dictionary:
    var _traits: = {}
    var traits_list: Array = ['vanity', 'humor']
    for i in traits_list:
        var x = load("res://character/personality/facets/" + i + ".tres")
        var t = Facet.new(x)
        if t is Facet:
            print(true)
        var value = Util.weighted_random(100, 5)
        _traits[t.get_trait_name()] = {"value": value, 'description': t.get_description(value)}
    return _traits

func determine_beliefs():
    pass

func determine_goals():
    pass