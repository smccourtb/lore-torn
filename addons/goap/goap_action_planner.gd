tool
extends Node
class_name GOAPActionPlanner

var state_atoms = [] # hold individual world describers [has_axe, sees_tree]
var actions = []

class State:
	var value: int
	var mask: int
	
	func _init(v, m):
		value = v
		mask = m
	
	func equals(state):
		return value == state.value and mask == state.mask
	
	func check(condition):
		return (condition.mask & mask) == condition.mask and (value & condition.mask) == condition.value
	
	func apply(effect):
		return get_script().new((value & mask & (~effect.mask)) | (effect.value & effect.mask), mask | effect.mask)
	
	func tostring(atoms = null):
		if atoms != null:
			var rv = PoolStringArray()
			for i in range(atoms.size()):
				if mask & (1 << i) != 0:
					if value & (1 << i) == 0:
						rv.append("!"+atoms[i])
					else:
						rv.append(atoms[i])
			return rv.join(" ")
		else:
			return "("+str(value)+", "+str(mask)+")"

class Action:
	var name: String
	var preconditions: State
	var effect: State
	var cost: float
	
	func _init(n, p, e, c):
		name = n
		preconditions = p
		effect = e
		cost = c

	func tostring(atoms = null):
		return name +"("+preconditions.tostring(atoms)+", "+effect.tostring(atoms)+", "+str(cost)+")"

class AStarNode:
	var state: State #!hungry sees_tree has_axe <- but just one
	var previous: int
	var last_action
	var cost: float
	
	func _init(s, p, la, c):
		state = s
		previous = p
		last_action = la
		cost = c

func _ready():
	parse_actions()

func state_index(n: String):
	var rv = state_atoms.find(n)
	if rv == -1:
		rv = state_atoms.size()
		state_atoms.append(n)
	return rv

func parse_state(string: String) -> State:
	# Takes a string (world bools and goals and outputs a State node
	# i ASSUME this is converting a string into some sort of ID
	# USES BITWISE BLACK MAGIC
	var value = 0
	var mask = 0
	var regex = RegEx.new()
	regex.compile("!?[\\w\\d_]+")
	# Splits the string up using regex (ex. 'has_axe' or 'sees_tree') and puts it into var n 
	for m in regex.search_all(string):
		var n = m.get_string()
		var v = true
		# Check for a NOT
		if n[0] == "!":
			v = false
		# This is voodoo to me. I have no idea whats happening
			n = n.right(1)
		var rv = 1 << state_index(n)
		mask |= rv
		if v:
			value |= rv
	return State.new(value, mask)

func clear_actions():
	state_atoms = []
	actions = []

func add_action(action_name, preconditions, effect, cost):
	var action = Action.new(action_name, parse_state(preconditions), parse_state(effect), cost)
	actions.append(action)

func parse_actions(sort_atoms : bool = false, keep_atoms = false): # O(n**2)
	# fuck are atoms?
	if !keep_atoms:
		state_atoms = []
	actions = []
	
	# Could change this to pick from a list and just pass the whole resource SM
	for a in get_children(): # for a in <list of action templates> SM
		add_action(a.name, a.preconditions, a.effect, a.cost)
	if !keep_atoms and sort_atoms:
		state_atoms.sort()
		actions = []
		for a in get_children():
			add_action(a.name, a.preconditions, a.effect, a.cost)

func plan(state, goal) -> Array:
	return plan_from_states(parse_state(state), parse_state(goal))

func plan_from_states(state : State, goal : State) -> Array:
	var nodes = []
	var ends = []			   #state #previous #last action #cost
	nodes.append(AStarNode.new(state, 0, null, 0))
	astar(nodes, ends, goal, 0)
	var best_cost = 100000
	var best_end = null
	for e in ends:
		if nodes[e].cost < best_cost:
			best_end = e
			best_cost = nodes[e].cost
	var plan = []
	if best_end != null:
		var i = best_end
		while nodes[i].last_action != null:
			var actions = nodes[i].last_action.split(" ")
			for j in actions.size():
				plan.insert(j, actions[j])
			i = nodes[i].previous
	return plan

func fix_nodes_cost(nodes, index_list, difference):
	for i in index_list:
		nodes[i].cost -= difference
	var new_index_list = []
	for i in nodes.size():
		if index_list.find(nodes[i].previous) != -1:
			new_index_list.append(i)
	if !new_index_list.empty():
		fix_nodes_cost(nodes, new_index_list, difference)

func state_to_string(s):
	return s.tostring(state_atoms)

func astar(nodes, ends, goal, index):
	print("Starting from node "+str(index))
	var node = nodes[index]
	for a in actions:
		#print(a.tostring(state_atoms))
		if node.state.check(a.preconditions):
			var next_state = node.state.apply(a.effect)
			var cost = node.cost + a.cost
			var found = false
#			print("  "+a.name+"("+state_to_string(a.preconditions)+", "+state_to_string(a.effect)+") -> "+state_to_string(next_state))
			for n in range(nodes.size()):
				if nodes[n].state.equals(next_state):
					found = true
					if nodes[n].cost > cost:
						#print("Found better cost for node "+str(n))
						nodes[n].last_action = a.name
						nodes[n].previous = index
						fix_nodes_cost(nodes, [n], nodes[n].cost - cost)
					break
			if !found:
				nodes.append(AStarNode.new(next_state, index, a.name, cost))
				if next_state.check(goal):
					ends.append(nodes.size()-1)
				else:
					astar(nodes, ends, goal, nodes.size()-1)
