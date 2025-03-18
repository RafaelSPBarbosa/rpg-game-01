extends Node3D
class_name XP_Point

@onready var is_close_to_player := false
@onready var speed : float = 0.0
@onready var max_speed : float = 20.0
@onready var acceleration : float = 30.0

@export var worth := 5.0

func _physics_process(delta):
	if is_close_to_player:
		speed += (acceleration / 100) * delta
		if speed >= max_speed:
			speed = max_speed
	else:
		speed -= (acceleration / 100) * delta
		if speed <= 0:
			speed = 0
	
	global_position += (Player.instance.body.global_position + Vector3(0,1.0,0) - global_position).normalized() * speed
	
	if global_position.distance_to(Player.instance.body.global_position + Vector3(0,1.0,0)) < 0.5:
		Player.instance.gain_xp(worth)
		Player.instance.collect_xp_point_sound.play()
		queue_free()

func _on_area_3d_area_entered(area):
	if area.is_in_group("Player"):
		is_close_to_player = true

func _on_area_3d_area_exited(area):
	if area.is_in_group("Player"):
		is_close_to_player = false
