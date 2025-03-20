extends Node3D
class_name Metal_Gate

@onready var animation_player = $AnimationPlayer

func activate():
	animation_player.play("MetalGate_Open")
