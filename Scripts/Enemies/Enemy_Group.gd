extends Node3D
class_name Enemy_Group

@onready var enemy_dictionary = {}

@export var quest_on_clear: String = ""
@export var villager_to_disable: Villager = null
@export var villager_to_enable: Villager = null

func register_enemy(enemy: Enemy):
	print (enemy)
	enemy_dictionary.assign({enemy.name: true})
	
func enemy_died(enemy: Enemy):
	if enemy_dictionary.has(enemy.name):
		enemy_dictionary[enemy.name] = false
	
	check_if_cleared()

func check_if_cleared():
	var has_survivors := false
	for enemy in enemy_dictionary.values():
		if enemy == true:
			has_survivors = true
	
	if !has_survivors:
		print(name + " has been cleared out!")
		UI.instance.quests.change_quest(quest_on_clear)
		if villager_to_enable != null:
			print("Enabling " + villager_to_enable.name)
			villager_to_enable.set_process(true)
			villager_to_enable.set_physics_process(true)
			villager_to_enable.set_process_input(true)
		if villager_to_disable != null:
			print("Disabling " + villager_to_disable.name)
			villager_to_disable.queue_free()
