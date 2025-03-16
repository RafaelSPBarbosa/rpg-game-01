extends CharacterBody3D
class_name Enemy

@export var health: float = 100
@export var max_health: float = 100
@export var move_speed = 5.0

@onready var character : CharacterSkin = $Skin/character
@onready var _skin = $"Skin"

@onready var area_3d = $Area3D
@onready var collision_shape_3d = $CollisionShape3D

#sounds
@onready var aggro_sound: AudioStreamPlayer3D = $AggroSound
@onready var death_sound: AudioStreamPlayer3D = $DeathSound
@onready var hit_sound: AudioStreamPlayer3D= $HitSound


enum ai_states {idle, chasing, attacking, waiting_to_strike, dead}
@onready var state : ai_states = ai_states.idle

@export var damage = 25.0
var attack_timer = 0
@export var attack_cooldown = 2

func _process(delta):
	if Player.instance.is_alive == false:
		state = ai_states.idle
		return
	
	if state == ai_states.idle:
		attack_timer = 0
		
		if global_position.distance_to(Player.instance.body.global_position) < 10:
			state = ai_states.chasing
			aggro_sound.play()
			
	if state == ai_states.waiting_to_strike:
		if(character.state_machine.get_current_node() != "Idle" && character.state_machine.get_current_node() != "Take Damage"):
			character.idle()
		if global_position.distance_to(Player.instance.body.global_position) > 2:
			state = ai_states.chasing


func _physics_process(delta):
	if Player.instance.is_alive == false:
		return
	
	if state == ai_states.chasing:
		attack_timer = 0
		
		if global_position.distance_to(Player.instance.body.global_position) > 2:
			velocity = (Player.instance.body.global_position - global_position).normalized() * move_speed
			velocity.y = 0
			character.move()
			
			var target_angle := Vector3.BACK.signed_angle_to(velocity, Vector3.UP)
			_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, 12 * delta)
		else:
			velocity = Vector3.ZERO
			if(character.state_machine.get_current_node() != "Idle" && character.state_machine.get_current_node() != "Take Damage"):
				character.idle()
				state = ai_states.waiting_to_strike
				
	if state == ai_states.waiting_to_strike:
		var target_angle := Vector3.BACK.signed_angle_to(Player.instance.body.global_position - global_position, Vector3.UP)
		_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, 12 * delta)
		
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			attack()
		
	move_and_slide()

func take_damage(damage: float):
	if health > 0:
		health -= damage
		print(name + " took " + str(damage) + " damage")
		hit_sound.play()
		if health <= 0:
			die()
		else:
			character.take_damage()
			
func attack():
	state = ai_states.attacking
	attack_timer = 0
	character.attack()
	Player.instance.take_damage(damage)
	await get_tree().create_timer(0.5).timeout
	state = ai_states.waiting_to_strike
	character.idle()

func die():
	character.die()
	area_3d.queue_free()
	collision_shape_3d.queue_free()
	state = ai_states.dead
	death_sound.play()
