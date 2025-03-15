extends CharacterBody3D
class_name Enemy

@export var health: float = 100
@export var max_health: float = 100

@onready var character = $Skin/character

@onready var area_3d = $Area3D
@onready var collision_shape_3d = $CollisionShape3D

func take_damage(damage: float):
	if health > 0:
		health -= damage
		print("took " + str(damage) + " damage")
		if health <= 0:
			die()
		else:
			character.take_damage()

func die():
	character.die()
	area_3d.queue_free()
	collision_shape_3d.queue_free()
