extends Node3D
class_name Fire_Trap

@onready var time_to_trigger := 0.0
@export var time_between_attacks = 3.0
@export var offset = 0.0

@onready var fire_particles: GPUParticles3D  = $Fire_Particles

@onready var is_active = false

@onready var is_player_inside = false

@onready var damage = 50.0

func _ready():
	await get_tree().create_timer(offset).timeout
	is_active = true

func _process(delta):
	if is_active == true:
		if time_to_trigger < Time.get_ticks_msec():
			time_to_trigger = Time.get_ticks_msec() + time_between_attacks * 1000
			trigger()

func trigger():
	fire_particles.emitting = true
	if is_player_inside == true:
		Player.instance.take_damage(damage)

func _on_area_3d_area_entered(area):
	if area.is_in_group("Player"):
		is_player_inside = true

func _on_area_3d_area_exited(area):
	if area.is_in_group("Player"):
		is_player_inside = false
