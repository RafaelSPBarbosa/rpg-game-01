extends CharacterBody3D
class_name PlayerMovement

@export_group("Movement")
@export var move_speed := 5.0
@export var acceleration := 40.0
@export var rotation_speed := 12.0

var _last_movement_direction := Vector3.BACK

@onready var _camera: Camera3D = $"../CameraPivot/SpringArm3D/Camera"
@onready var _skin = $"Skin"
@onready var _skin_character = $"Skin/character"
	
func _physics_process(delta):
	var raw_input := Input.get_vector("move_left","move_right","move_forward","move_backwards")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction	
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)
	
	var ground_speed := velocity.length()
	if ground_speed > 0.2:
		_skin_character.move()
	else:
		_skin_character.idle()
	
