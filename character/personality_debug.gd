extends Control

onready var need_ui: MarginContainer = $VB/NeedUI
onready var need_ui_container: VBoxContainer = $VB
var personality_data: PersonalityController

func _ready() -> void:
	need_ui.setup_need_bars(personality_data.need_controller.needs)

