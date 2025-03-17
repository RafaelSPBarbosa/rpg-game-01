extends Node3D
class_name Player

static var instance: Player = null
func _init() -> void: instance = self

var is_alive := true

@onready var is_busy := false

#stats
@onready var health := 100
@onready var max_health := 100
@onready var xp := 0
@onready var xp_by_levels: Array[int] = [
	10,
	20,
	40,
	80,
	160
]
@onready var skill_points = 5

#Attributes
@onready var endurance := 1
@onready var agility := 1
@onready var speed := 1
@onready var luck := 1
@onready var strength := 1

@onready var time_to_regain_health := 0

@onready var character = $Body/Skin/character
@onready var body = $Body
@onready var skin = $Body/Skin

@onready var death_sound : AudioStreamPlayer3D = $Body/DeathSound
@onready var hit_sound : AudioStreamPlayer3D = $Body/HitSound

func _ready():
	time_to_regain_health = Time.get_ticks_msec() + get_health_regen_rate()

func _physics_process(delta):
	if Time.get_ticks_msec() >= time_to_regain_health:
		time_to_regain_health = Time.get_ticks_msec() + get_health_regen_rate()
		regenerate_health()
		
func regenerate_health():
	health += max_health / 100
	if health > max_health:
		health = max_health
	
func get_health_regen_rate():
	return 1000.0 / (endurance / 5)

func take_damage(damage: float):
	if health > 0:
		health -= damage
		hit_sound.play()
		print("Player took " + str(damage) + " damage")
		if health <= 0:
			die()
		else:
			character.take_damage()
			
func die():
	character.die()
	death_sound.play()
	is_alive = false
