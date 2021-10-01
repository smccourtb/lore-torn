extends StaticBody2D
class_name ResourceNode
export var hits: int
export var type: String
export var subtype: String
export var state: String
export var node_resource: Resource
export var drops: Array
var selected: bool = false setget set_selected
onready var Tooltip
func _ready():
	setup_node(node_resource)
	
	var a = PlayerStats.get(node_resource.skill.to_lower()+'_level')
	check_gathering_level(a)
	Tooltip = preload("res://_UI/NodeTooltip.tscn")

func _on_HurtBox_area_entered(_area):
	$Particles2D.emitting = true
	if $HurtBox/CollisionShape2D.disabled == true:
		return
	if type == 'tree':
		$AnimatedSprite.play(subtype + '_left')
		$AnimatedSprite.frame = 0
	hits -= 1
	if hits <= 0:
		node_resource.state = 'empty'
		SignalBus.emit_signal('empty_node')
		node_resource.position = position
		call_deferred('spawn_items')
		SignalBus.emit_signal("state_changed", node_resource)
		SignalBus.emit_signal("skill_up", str(node_resource.skill).to_lower())
		call_deferred('empty_node')
		


func setup_node(var _bloom):
	if !node_resource:
		var new_resource = load("res://Resources/Nodes/" + type + "_" + subtype + ".tres")
		node_resource = new_resource.duplicate()
	state = node_resource.state
	hits = node_resource.hits
	type = node_resource.type
	subtype = node_resource.subtype
	drops = node_resource.drops
	$Sprite.texture = node_resource.texture
	$'Shadow'.texture = node_resource.shadow_texture
	
	
	if subtype == 'pine':
		$AnimatedSprite.position.y = -16
		$AnimatedSprite.position.x = 0
	if subtype == 'willow':
		$AnimatedSprite.position.y = -20
		$AnimatedSprite.position.x = -4
	if subtype == 'birch':
		$AnimatedSprite.position.y = -26
		$AnimatedSprite.position.x = -4
	else:
		$AnimatedSprite.position.y = -13
		$AnimatedSprite.position.x = 0
	
	
	
	if state == 'full':
		
		$Sprite.region_rect = node_resource.full_texture_rect
		$Sprite.position = node_resource.full_texture_position
		$'Shadow'.region_rect = node_resource.full_shadow_rect
		$'Shadow'.position = node_resource.full_shadow_position
		if type == 'tree':
			$AnimatedSprite.visible = true
			$AnimatedSprite.animation = str(subtype+'_left')
			$AnimatedSprite.stop()
		else:
			$AnimatedSprite.visible = false
	else:
		empty_node()
		


func empty_node():
	$AnimatedSprite.visible = false
	$Sprite.region_rect = node_resource.empty_texture_rect
	$Sprite.position = node_resource.empty_texture_position
	$'Shadow'.region_rect = node_resource.empty_shadow_rect
	$'Shadow'.position = node_resource.empty_shadow_position
	$HurtBox/CollisionShape2D.disabled = true

func spawn_items():
	# TODO: Add a more elegant way of deciding what to drop and how much
	var at = position
	var count = 2
	var spacing = 2 * PI / count
	for i in count:
		var item = load("res://Resources/Items/Collectable.tscn").instance()
		var x = Util.choose(drops)
		item.title = x.name
		print(x.name)
		add_child(item)
		item.sprite.texture = x.texture
		# Offset the angle based on the iteration
		var angle = spacing * i
		# add a bit of randomization to scatter it about
		angle += rand_range(0, spacing) - spacing * 0.5
		item.spawn(at, angle)
		
		#item.sprite.region_rect = x.texture_region


func _on_HurtBox_mouse_entered():
	var tooltip = Tooltip.instance()
	add_child(tooltip)
	#yield(get_tree().create_timer(1.5), 'timeout')
	#$PopupMenu.rect_position = global_position
	#$PopupMenu.popup()


func _on_HurtBox_mouse_exited():
	SignalBus.emit_signal('tooltip')


func check_gathering_level(skill_level):
	if skill_level < node_resource.skill_level:
		$HurtBox/CollisionShape2D.disabled = true


func _on_Targeted(who):
	if who == self and !has_node('TargetedMarker'):
		var target_effect = load("res://_UI/Target.tscn").instance()
		add_child(target_effect)
		move_child(target_effect, 0)
		target_effect.get_node('Target').play("node")
	else:
		if has_node('TargetedMarker'):
			get_node('TargetedMarker').queue_free()
	


func _on_PopupMenu_index_pressed(index):
	print(index)

func set_selected(boo: bool):
	selected = boo
	var selector = load("res://Selector.tscn").instance()
	add_child(selector)
	get_parent().resource_node_positions.append(global_position)
