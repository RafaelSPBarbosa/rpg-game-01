extends Control
class_name Level_Up_Screen

@onready var level_indicator = $Level_Indicator

func _ready():
	modulate.a = 0.0

func show_screen(level: int):
	level_indicator.text = "Level " + str(level)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(5).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)
