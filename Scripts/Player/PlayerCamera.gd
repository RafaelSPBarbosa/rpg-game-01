extends Node

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

var _camera_input_direction := Vector2.ZERO

@onready var _camera_pivot: Node3D = $"."
@onready var _body: Node3D = $"../Body"

func _input(event: InputEvent) -> void:
	if(Player.instance.is_busy):
		return
		
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			_camera_input_direction = event.screen_relative * mouse_sensitivity
		
func _process(delta):
	if Player.instance.is_busy == true:
		return
		
	_camera_pivot.position = _body.position

func _physics_process(delta: float) -> void:
	if Player.instance.is_busy == true:
		return
			
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0, PI / 3.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
		
	_camera_input_direction = Vector2.ZERO
