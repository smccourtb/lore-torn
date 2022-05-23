extends Control

onready var need_ui: MarginContainer = $HB/VB/NeedUI
var personality_data: PersonalityController

func _ready() -> void:
	need_ui.setup_need_bars(personality_data.need_controller.needs)

func setup_needs():
	need_ui.setup_need_bars(personality_data.need_controller.needs)
