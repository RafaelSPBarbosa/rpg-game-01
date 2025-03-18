extends Control
class_name UI

static var instance: UI = null
func _init() -> void: instance = self

@onready var dialog_panel: Dialog_Panel = $Dialog_Panel
@onready var quests: Quest_System = $Quests
@onready var health: Health_Bar = $Health
@onready var buttons: Control = $Buttons
@onready var character_stats_screen: Character_Stats_Screen = $Character_Stats_Screen
@onready var xp_bar: XP_Bar = $XPBar

func hide_ui():
	var tween = get_tree().create_tween()
	tween.tween_property(buttons, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(quests, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(health, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	var tween4 = get_tree().create_tween()
	tween4.tween_property(xp_bar, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	
	
func show_ui():
	var tween = get_tree().create_tween()
	tween.tween_property(buttons, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(quests, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(health, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	var tween4 = get_tree().create_tween()
	tween4.tween_property(xp_bar, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
