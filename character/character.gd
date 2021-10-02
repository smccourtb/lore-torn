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
var height: int
var weight: int
var genes: Dictionary = {}
var personality: Resource
var mood_level: Dictionary

var assigned_jobs: = []
var energy_level: int = 100
# THINGS TO ADD
# memories

func _init() -> void:
	self.id = get_instance_id()
	set_personality()

func set_race_data(new_race_data: Resource) -> void:
	self.race_data = new_race_data

func get_race_data() -> Resource:
	return self.race_data

func get_id() -> int:
	return self.id
	
func set_race(new_race: String) -> void:
	self.race = new_race

func get_race() -> String:
	return self.race

func set_age(new_age:int) -> void:
	self.age = new_age

func get_age() -> int:
	return self.age

func get_gender() -> String:
	return self.gender

func set_gender(new_gender: String) -> void:
	# I'd imagine this will trigger a recalc somewhere. Should be rarely used if ever
	self.gender = new_gender
	
func get_position() -> Vector2:
	return self.position

func set_position(new_pos: Vector2) -> void:
	self.position = new_pos

func get_name() -> String:
	return self.name

func set_name(new_name: String) -> void:
	self.name = new_name

func get_height() -> int:
	return self.height

func set_height(new_height: int) -> void:
	self.height = new_height

func get_weight() -> int:
	return self.weight

func set_weight(new_weight: int) -> void:
	self.weight = new_weight

func set_birthday():
	# stored in minutes
	self.birthday = Global.time.value

func get_birthday() -> int:
	# TODO: convert age into years and subtract from time
	return self.birthday

func get_assigned_jobs():
	pass

func assign_new_job(new_job: String) -> void:
	assigned_jobs.append(new_job)

func remove_assigned_job(job: String) -> void:
	for i in assigned_jobs:
		if job == i:
			assigned_jobs.erase(i)
		print("THE JOB YOU WANT TO REMOVE IS INDEED ASSIGNED BUT I HAVE NOT BEEN SET UP TO REMOVE IT YET")


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
	check_personality_compatibility(closest)

func find_closest():
	# TODO: add parameter for what to search for
	var closest: float = INF
	var ref: Resource
	for i in Global.population:
		if self.position.distance_squared_to(i.position) < closest:
			closest = self.position.distance_squared_to(i.position)
			ref = i
	return ref

func check_personality_compatibility(converser):
	# sum difference between all facets, sets/updates conversation count,
	# stores data in realtionship dict
	# TODO: move into personalty class
	# TODO: break up into separate functions
	# TODO: Add check if converser can communicate
	# TODO: Add check if they can speak the same language
	var total: float = 0
	for i in personality.facets:
		var dif = personality.facets[i].value - converser.personality.facets[i].value
		total += abs(dif)
	var conversed_count: int = 1
	if relationships.has(converser.id):
		conversed_count += 1

	relationships[converser.id] = {"points": total, 'conversed': conversed_count}

func determine_max_possible_height() -> int:
	var max_height = self.race_data.max_height
	var count: int = 0
	var race_height_diff = max_height - self.race_data.min_height
	for i in self.genes.height.genotype:
		count += i.dominant
	if count > 1:
		var min_height = max_height - round(race_height_diff * .25) 
		return Util.choose([min_height, max_height])
	elif count > 0:
		var min_height = max_height - round(race_height_diff * .50)
		return Util.choose([min_height, max_height])
	return Util.choose([self.race_data.min_height, round(self.race_data.min_height + (max_height *.50))])
		

func determine_genes():
	pass

func set_personality() -> void:
	self.personality = determine_personality()

func get_personalty() -> Resource:
	return self.personality
	
func determine_personality() -> Personality:
	return Personality.new()
