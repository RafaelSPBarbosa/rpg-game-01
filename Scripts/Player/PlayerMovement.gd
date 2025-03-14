extends CharacterBody3D
class_name PlayerMovement

@export_group("Movement")
@export var move_speed = 5.0

@onready var _camera: Camera3D = $"../Camera"

func _ready():
	
	return
	
func _physics_process(delta):
	var raw_input := Input.get_vector("move_left","move_right","move_forward","move_backwards")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = move_direction * move_speed
	move_and_slide()
