extends CharacterBody3D
class_name PlayerMovement

@export_group("Movement")
@export var move_speed := 5.0
@export var acceleration := 40.0
@export var rotation_speed := 12.0

var _last_movement_direction := Vector3.BACK

@onready var _camera: Camera3D = $"../CameraPivot/SpringArm3D/Camera"
@onready var _skin = $"Skin"
@onready var _skin_character: CharacterSkin = $"Skin/character"

var time_between_footsteps := 0.2
var cur_time_between_footsteps := 0.0
@onready var footstep_sound : AudioStreamPlayer3D = $FootstepSound
	
func _physics_process(delta):
	if Player.instance.is_alive == false:
		return
		
	if Player.instance.is_busy == true:
		return

	var raw_input := Input.get_vector("move_left","move_right","move_forward","move_backwards")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	if _skin_character.state_machine.get_current_node() == "Attack":
		move_direction = Vector3.ZERO
		
	if _skin_character.state_machine.get_current_node() == "Take Damage":
		move_direction = Vector3.ZERO
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction	
		cur_time_between_footsteps += delta
		if(cur_time_between_footsteps >= time_between_footsteps):
			footstep_sound.pitch_scale = randf_range(0.75, 1.25)
			footstep_sound.play()
			cur_time_between_footsteps = 0
	else:
		cur_time_between_footsteps = 0
		
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)
	
	var ground_speed := velocity.length()
	if ground_speed > 0.2:
		_skin_character.move()
	else:
		if _skin_character.state_machine.get_current_node() != "Take Damage":
			_skin_character.idle()
	
