extends Node3D
class_name Villager

@onready var is_player_in_range = false
@onready var is_talking_to_player = false

@onready var player_talk_position = $PlayerTalkPosition
@onready var camera_3d = $Camera3D

@export var next_villager: Node3D = null

@export var lines : Array[String] = []
var cur_line := 0

func _on_area_3d_area_entered(area):
	is_player_in_range = true

func _on_area_3d_area_exited(area):
	is_player_in_range = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_player_in_range == true:
			if is_talking_to_player == false:
				is_talking_to_player = true
				Player.instance.is_busy = true
				Player.instance.body.global_position = player_talk_position.global_position
				Player.instance.skin.global_rotation = player_talk_position.global_rotation
				Player.instance.character.idle()
				camera_3d.current = true
				cur_line = 0
				say_line(lines[cur_line])
				print("Player started talking to villager " + get_parent().get_parent().name)
				return
				
		if is_talking_to_player == true:
			if cur_line < lines.size() - 1:
				cur_line += 1
				say_line(lines[cur_line])
			else:
				is_talking_to_player = false
				Player.instance.is_busy = false
				camera_3d.current = false
				print("Player stopped talking to villager " + get_parent().get_parent().name)
				if next_villager != null:
					next_villager.visible = true
					reparent(null)
					print("Replacing " + get_parent().get_parent().name + " with " + next_villager.name)
			return

func say_line(line: String):
	print(line)
