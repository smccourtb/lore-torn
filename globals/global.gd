extends Node

# we need to hold all the characters in the 'tribe'
var population = []

var resource_nodes: = []

var jobs: Array = ["chop", "mine", "gather"]

var items: = {}

var stockpiles: = []

var walkable_cells = []

# Some sort of global item to id thang: so 
# Right in the beginnning do it every every single item and resource and thing in the game
# oak_tree -> hash
# store in a dictionary
# i need the item
