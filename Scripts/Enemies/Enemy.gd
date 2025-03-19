extends Node3D
class_name Enemy

@export_group("Stats")
@export var health: float = 100
@export var max_health: float = 100
@export var move_speed = 5.0

var group: Enemy_Group = null

@onready var body = $Body
@onready var character : CharacterSkin = $Body/Skin/character
@onready var _skin = $"Body/Skin"

@onready var area_3d = $Body/Area3D
@onready var collision_shape_3d = $Body/CollisionShape3D
@onready var critical_strike_icon = $Critical_Strike_Icon

#sounds
@onready var aggro_sound: AudioStreamPlayer3D = $Body/AggroSound
@onready var death_sound: AudioStreamPlayer3D = $Body/DeathSound
@onready var hit_sound: AudioStreamPlayer3D = $Body/HitSound

@onready var initial_position: Vector3 = Vector3.ZERO
@onready var initial_rotation: Vector3 = Vector3.ZERO

enum ai_states {idle, chasing, attacking, waiting_to_strike, dead, returning_to_spawn}
@onready var state : ai_states = ai_states.idle

@export var damage = 25.0
var attack_timer = 0
@export var attack_cooldown = 2

func _ready():
	initial_position = body.global_position
	initial_rotation = _skin.global_rotation
	group = get_parent()
	await get_tree().create_timer(0.1).timeout
	group.register_enemy(self)

func _process(delta):
	if Player.instance.is_alive == false:
		state = ai_states.idle
		return
	
	if state == ai_states.idle:
		attack_timer = 0
		
		if body.global_position.distance_to(Player.instance.body.global_position) < 10:
			state = ai_states.chasing
			aggro_sound.play()
			
	if state == ai_states.waiting_to_strike:
		if(character.state_machine.get_current_node() != "Idle" && character.state_machine.get_current_node() != "Take Damage"):
			character.idle()
		if body.global_position.distance_to(Player.instance.body.global_position) > 2:
			state = ai_states.chasing


func _physics_process(delta):
	if Player.instance.is_alive == false:
		return
	
	if state == ai_states.chasing:
		attack_timer = 0
		
		if body.global_position.distance_to(initial_position) > 10:
			state = ai_states.returning_to_spawn
		
		if body.global_position.distance_to(Player.instance.body.global_position) > 2:
			body.velocity = (Player.instance.body.global_position - body.global_position).normalized() * move_speed
			body.velocity.y = 0
			character.move()
			
			var target_angle := Vector3.BACK.signed_angle_to(body.velocity, Vector3.UP)
			_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, 12 * delta)
		else:
			body.velocity = Vector3.ZERO
			if(character.state_machine.get_current_node() != "Idle" && character.state_machine.get_current_node() != "Take Damage"):
				character.idle()
				state = ai_states.waiting_to_strike
				
	if state == ai_states.waiting_to_strike:
		var target_angle := Vector3.BACK.signed_angle_to(Player.instance.body.global_position - body.global_position, Vector3.UP)
		_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, 12 * delta)
		
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			attack()
		
	if state == ai_states.returning_to_spawn:
		body.velocity = (initial_position - body.global_position).normalized() * move_speed
		body.velocity.y = 0
		character.move()
		var target_angle := Vector3.BACK.signed_angle_to(initial_position - body.global_position, Vector3.UP)
		_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, 12 * delta)
		
		if body.global_position.distance_to(initial_position) < 0.5:
			body.velocity = Vector3.ZERO
			body.global_position = initial_position
			_skin.global_rotation = initial_rotation
			character.idle()
			state = ai_states.idle
		
	body.move_and_slide()

func take_damage(damage: float, is_critical: bool = false):
	if health > 0:
		health -= damage
		print(name + " took " + str(damage) + " damage")
		hit_sound.play()
		
		if is_critical:
			var initial_critical_icon_pos = body.global_position + Vector3(0,1,0)
			critical_strike_icon.global_position = initial_critical_icon_pos
			critical_strike_icon.modulate.a = 1.0
			var tween = get_tree().create_tween()
			tween.tween_property(critical_strike_icon, "global_position:y", initial_critical_icon_pos.y + 2.0, 1.0).set_ease(Tween.EASE_OUT)
			var tween2 = get_tree().create_tween()
			tween2.tween_property(critical_strike_icon, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_OUT)
		
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
	group.enemy_died(self)
	Player.instance.gain_xp(5)
