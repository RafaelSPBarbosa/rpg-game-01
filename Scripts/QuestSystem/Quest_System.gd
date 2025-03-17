extends Control
class_name Quest_System

@onready var current_quest: Label = $Current_Quest
@onready var icon = $Current_Quest/Icon
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func change_quest(description: String):
	await get_tree().create_timer(1.0).timeout
	icon.scale = Vector2.ONE * 15
	icon.modulate.a = 0.5
	var tween = get_tree().create_tween()
	tween.tween_property(icon, "scale", Vector2.ONE, .5).set_ease(Tween.EASE_IN_OUT)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(icon, "modulate:a", 1.0, .3).set_ease(Tween.EASE_IN)
	current_quest.text = description
	audio_stream_player_3d.play()
