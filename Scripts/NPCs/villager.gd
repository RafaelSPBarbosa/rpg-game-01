extends Node
class_name Villager

@onready var is_player_in_range = false
@onready var is_talking_to_player = false

@onready var player_talk_position = $Body/PlayerTalkPosition
@onready var camera_3d = $Body/Camera3D

@onready var interact_tooltip = $InteractTooltip
@onready var interact_tooltip_initial_position := Vector3.ZERO

@export var display_name: String

@export var next_villager: Node3D = null
@export var start_enabled: bool = true
@export var animatable_structure: Animatable_Structure = null

@export var lines: Array[String] = []
@onready var cur_line := 0
@export var quest: String = ""

func _ready():
	interact_tooltip_initial_position = interact_tooltip.global_position
	interact_tooltip.global_position.y -= 0.5
	interact_tooltip.modulate.a = 0.0
	
	if start_enabled == false:
		set_process(false)
		set_physics_process(false)
		set_process_input(false)

func _on_area_3d_area_entered(area):
	if area.is_in_group("Player"):
		is_player_in_range = true
		var tween = get_tree().create_tween()
		tween.tween_property(interact_tooltip, "modulate:a", 1.0, .25).set_ease(Tween.EASE_OUT)
		tween.tween_property(interact_tooltip, "global_position:y", interact_tooltip_initial_position.y, 0.25).set_ease(Tween.EASE_OUT)
		

func _on_area_3d_area_exited(area):
	if area.is_in_group("Player"):
		is_player_in_range = false
		var tween = get_tree().create_tween()
		tween.tween_property(interact_tooltip, "modulate:a", 0.0, .25).set_ease(Tween.EASE_OUT)
		tween.tween_property(interact_tooltip, "global_position:y", interact_tooltip_initial_position.y - 0.5, 0.25).set_ease(Tween.EASE_OUT)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_player_in_range == true:
			if is_talking_to_player == false:
				print("Player started talking to villager " + name)
				is_talking_to_player = true
				Player.instance.is_busy = true
				Player.instance.body.global_position = player_talk_position.global_position
				Player.instance.skin.global_rotation = player_talk_position.global_rotation
				Player.instance.character.idle()
				camera_3d.current = true
				cur_line = 0
				say_line(lines[cur_line])
				return
				
		if is_talking_to_player == true:
			if cur_line < lines.size() - 1:
				cur_line += 1
				say_line(lines[cur_line])
			else:
				is_talking_to_player = false
				cur_line = 0
				Player.instance.is_busy = false
				camera_3d.current = false
				print("Player stopped talking to villager " + name)
				UI.instance.dialog_panel.end()
				if quest != "":
					UI.instance.quests.change_quest(quest)
				if animatable_structure != null:
					animatable_structure.play()
				if next_villager != null:
					next_villager.set_process(true)
					next_villager.set_physics_process(true)
					next_villager.set_process_input(true)
					queue_free()
					print("Replacing " + name + " with " + next_villager.name)
			return

func say_line(line: String):
	UI.instance.dialog_panel.start_or_write(display_name, line)
	print("Dialog with " + display_name + ": " + line)
