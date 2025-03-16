extends Node3D
class_name Animatable_Structure

@onready var animation_player = $AnimationPlayer
@export var animation_name: String = ""
@onready var sound = $Sound

func play():
	animation_player.play(animation_name)
	sound.play()
