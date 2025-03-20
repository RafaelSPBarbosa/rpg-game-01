extends Node3D
class_name Interactable_Button

@onready var is_player_in_range = false
@onready var is_talking_to_player = false

@onready var player_talk_position = $Body/PlayerTalkPosition
@export var camera_3d: Camera3D

@onready var interact_tooltip = $InteractTooltip
@onready var interact_tooltip_initial_position := Vector3.ZERO
@onready var animation_player = $Body/Skin/Lever/AnimationPlayer

@export var target: Node3D = null

@export var start_enabled: bool = true

func _ready():
	interact_tooltip_initial_position = interact_tooltip.global_position
	interact_tooltip.global_position.y -= 0.5
	interact_tooltip.modulate.a = 0.0
	
	if start_enabled == false:
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		visible = false

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
				print("Player used button " + name)
				animation_player.play("Armature|Lever_Use")
				is_talking_to_player = true
				Player.instance.is_busy = true
				Player.instance.character.idle()
				UI.instance.hide_ui()
				await get_tree().create_timer(2.0).timeout
				camera_3d.current = true
				await get_tree().create_timer(2.0).timeout
				if target != null:
					target.activate()
				await get_tree().create_timer(4.0).timeout
				is_talking_to_player = false
				Player.instance.is_busy = false
				Player.instance.camera.current = true
				camera_3d.current = false;
				UI.instance.show_ui()
				return
