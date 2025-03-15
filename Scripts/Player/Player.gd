extends Node3D
class_name Player

static var instance: Player = null
func _init() -> void: instance = self

var is_alive := true

@onready var health := 100
@onready var max_health := 100

@onready var character = $Body/Skin/character
@onready var body = $Body

func take_damage(damage: float):
	if health > 0:
		health -= damage
		print("Player took " + str(damage) + " damage")
		if health <= 0:
			die()
		else:
			character.take_damage()
			
func die():
	character.die()
	is_alive = false
