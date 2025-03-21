extends Node3D
class_name Player

static var instance: Player = null
func _init() -> void: instance = self

var is_alive := true

@onready var is_busy := false

#stats
@onready var health := 100.0
@onready var max_health := 100.0
@onready var xp := 0
@onready var xp_by_levels: Array[int] = [
	10,
	20,
	40,
	80,
	160,
	320,
	640,
	880,
	1760
]
@onready var level = 1
@onready var skill_points = 5

#Attributes
@onready var endurance := 1
@onready var agility := 1
@onready var speed := 1
@onready var luck := 1
@onready var strength := 1

@onready var time_to_regain_health := 0

@onready var character: CharacterSkin = $Body/Skin/character
@onready var body: PlayerMovement = $Body
@onready var skin = $Body/Skin
@onready var camera : Camera3D = $CameraPivot/SpringArm3D/Camera

@onready var death_sound : AudioStreamPlayer3D = $Body/DeathSound
@onready var hit_sound : AudioStreamPlayer3D = $Body/HitSound
@onready var level_up_sound = $Body/LevelUpSound
@onready var collect_xp_point_sound = $Body/Collect_XP_Point_Sound
@onready var equip_sword_sound = $Body/Equip_Sword_Sound

@onready var spawn_pos := Vector3.ZERO
@onready var spawn_rot := Vector3.ZERO

@onready var sword_basic = $Body/Skin/character/Armature/Skeleton3D/BoneAttachment3D/Sword_Basic

func _ready():
	time_to_regain_health = Time.get_ticks_msec() + 1000
	sword_basic.visible = false
	spawn_pos = body.global_position
	spawn_rot = body.global_rotation
	
func _input(event: InputEvent) -> void:
	if is_alive == false:
		if event.is_action_pressed("interact"):
			respawn()

func _physics_process(delta):
	if Time.get_ticks_msec() >= time_to_regain_health:
		time_to_regain_health = Time.get_ticks_msec() + 1000
		regenerate_health()
		
func regenerate_health():
	health += 1.0 * endurance
	if health > max_health:
		health = max_health
		
	UI.instance.health.update_bar()

func take_damage(damage: float):
	if health > 0:
		health -= damage
		hit_sound.play()
		print("Player took " + str(damage) + " damage")
		if health <= 0:
			health = 0
			die()
		else:
			character.take_damage()
			
		UI.instance.health.update_bar()

func die():
	character.die()
	death_sound.play()
	is_alive = false
	UI.instance.hide_ui()
	UI.instance.show_death_ui()
	
func respawn():
	character.idle()
	is_alive = true
	body.global_position = spawn_pos
	body.global_rotation = spawn_rot
	health = max_health / 2
	UI.instance.show_ui()
	UI.instance.hide_death_ui()

func gain_xp(amount: int):
	xp += amount * (1.0 + (float(luck) / 10))
	
	var has_levels_to_gain = true
	while has_levels_to_gain:
		if(xp_by_levels.size() > level):		
			if(xp >= xp_by_levels[level - 1]):
				level_up()
			else:
				has_levels_to_gain = false
		else:
			xp = xp_by_levels[level - 1] - 1
			has_levels_to_gain = false
		
	UI.instance.xp_bar.update_bar()
		
func level_up():
	xp -= xp_by_levels[level - 1]
	level += 1
	level_up_sound.play()
	skill_points += 5
	print("Player leveled up to level " + str(level))

func update_max_health():
	max_health = 100 * (1.0 + (float(endurance) / 10))
	print(max_health)
