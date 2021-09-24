extends Resource
class_name Character

# Need to provide race_data (character_template.gd)
var race_data: Resource
var id: int
var position: Vector2
var relationships: = {}
var race: String
var gender: String
var age: int
var name: String
var height: int # might rename to current height
var weight: int
var eye_color_gene: Gene
var height_gene: Gene
var max_possible_height: int #inches
var personality: Resource
var mood_level: Dictionary

func _init() -> void:
	self.id = get_instance_id()
	


func character_data() -> Dictionary:
	return {"race": self.race, 
			"age": self.age, 
			"name": self.name,
			"gender": self.gender, 
			"height": self.height, 
			"weight": self.weight,
			"eye_color": self.eye_color_gene.get_phenotype()
			}

func get_description() -> String:
	#TODO: add a check if there is a description OR just add a neutral description to facets.
	return ("""Here is a %s %s! %s goes by the name of %s. 
	%s is %s'%s tall, weighs %slbs, and %s is %s years old.
	%s eyes are the color %s. %s %s and %s %s. %s wants to %s. %s %s."""
		% [self.gender, self.race, determine_pronoun().subject.capitalize(), self.name, 
		determine_pronoun().subject.capitalize(), floor(float(self.height) / 12), self.height % 12, 
		self.weight, determine_pronoun().subject, self.age, determine_pronoun().possesive.capitalize(),
		self.eye_color_gene.get_phenotype(), determine_pronoun().subject.capitalize(), self.personality.facets.humor.description,
		determine_pronoun().subject.capitalize(), self.personality.facets.vanity.description, determine_pronoun().subject.capitalize(), 
		self.personality.goals["Goals"], determine_pronoun().subject.capitalize(), self.personality.beliefs.family.description])

func determine_pronoun():
	if self.gender == "male":
		return {"subject": "he", 
				"possesive": "his",
				"object": "him"}
	elif self.gender == "female":
		return {"subject": "she", 
				"possesive": "her",
				"object": "her"}

func tell_a_joke():
	if personality.facets.humor.value > 50:
		print('IT IS AND THIS WORKS')

func have_conversation():
	var closest = find_closest()
	if !closest:
		return
	# Make sure they like each other
	var compatibility = check_personality_compatibility(closest)
	print(compatibility)

func find_closest():
	var closest: float = INF
	var ref: Resource
	for i in Global.population:
		if self.position.distance_squared_to(i.position) < closest:
			closest = self.position.distance_squared_to(i.position)
			ref = i
	return ref

func check_personality_compatibility(converser):

	

	# TODO: Maybe this should be run whenever someone gets added to the population array and every month or 3 months or year (in game time)
	# This will be greatly expanded as things develop
	# OPTION A
	# var common_ground: = []
	# for i in personality.facets:
	# 	for j in converser.personality.facets:
	# 		var dif = personality.facets[i].value - converser.personality.facets[i].value 
	# 		if abs(dif) < 10:
	# 			common_ground.append(i)
	# if common_ground.size() > 0:
	# 	return Util.choose(common_ground)
	# return null
	# OPTION B
	var total: float = 0
	for i in personality.facets:
		var dif = personality.facets[i].value - converser.personality.facets[i].value
		total += abs(dif)
	var conversed_count: int = 1
	if relationships.has(converser.id):
		conversed_count += 1
	print('total: ', total)

	relationships[converser.id] = {"points": total, 'conversed': conversed_count}

	# Loop through all  facets and beliefs
	# get difference between the two
	# sum as you go
	# save character id or name and the sum. the lower the score the more they are compatible
	# beliefs could be worth 2 points instead of one as you choose your beliefs not your facets
	# goals could be worth 3
	# need to have a certain threshold to get married or be in a relationship
	# levels and number of times conversed should be variables to decide when relationship changes occur (ie. acquantance -> friend)
	# Relationship object should look like {id or name: [personality compatibility number, times talked, relationship level] } 
	
