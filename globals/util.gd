tool
extends Node


# Util.choose(["one", "two"])   returns one or two
func choose(choices):
	randomize()
	var rand_index = randi() % choices.size()
	return choices[rand_index]

# the percent chance something happens
func chance(num):
	randomize()
	if randi() % 100 <= num:  return true
	else:                     return false

# returns random int between low and high
func randi_range(low, high):
	return floor(rand_range(low, high))

# shuffle the order of an array
func shuffle(array):
	randomize()
	var shuffled = []
	var indexes = range(array.size())
	for _i in range(array.size()):
		var x = randi() % indexes.size()
		shuffled.append(array[indexes[x]])
		indexes.remove(x)
	return shuffled

func titlefy(text) -> String:
	return text.replace('_', ' ').capitalize()

func filenameify(text) -> String:
	return text.replace(' ', '_').to_lower()

	# [series(0,39),series(40,59),series(60,99)]
func weighted_random(max_num, numDice):
	var num = 0;
	for _i in range(numDice):
		# randomly picks a number from 1-100
		num += randf() * (max_num/numDice);
	return round(num)
