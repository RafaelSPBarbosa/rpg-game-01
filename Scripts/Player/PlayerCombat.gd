extends Node

@export_group("Combat")
var is_on_cooldown = false;
@export var attack_cooldown = 0.5

@onready var character = $".."
@onready var body = $".."
@onready var area_3d = $Area3D

var hittable_enemy_list = []

#sounds
@onready var sword_swing_sound = $"../../../SwordSwingSound"


func _input(event: InputEvent) -> void:
	if Player.instance.is_alive == false:
		return
		
	if event.is_action_pressed("attack"):
		if is_on_cooldown == false:
			character.attack()
			sword_swing_sound.play()
			is_on_cooldown = true
			await get_tree().create_timer(0.1).timeout
			if character.state_machine.get_current_node() == "Attack":
				cause_damage();
			await get_tree().create_timer(attack_cooldown).timeout
			is_on_cooldown = false
			
func cause_damage():
	for i in hittable_enemy_list:
		i.take_damage(50)


func _on_area_3d_area_entered(area):
	if area.is_in_group("Enemy"):
		var enemy = area.get_parent()
		var index = hittable_enemy_list.rfind(enemy)
		if index == -1:
			hittable_enemy_list.append(enemy)

func _on_area_3d_area_exited(area):
	if area.is_in_group("Enemy"):
		var enemy = area.get_parent()
		var index = hittable_enemy_list.rfind(enemy)
		if index > -1:
			hittable_enemy_list.remove_at(index)
