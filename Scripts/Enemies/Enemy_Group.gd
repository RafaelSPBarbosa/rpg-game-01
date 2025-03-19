extends Node3D
class_name Enemy_Group

@onready var enemy_dictionary = {}

@export var quest_on_clear: String = ""
@export var villagers_to_disable: Array[Villager] = []
@export var villagers_to_enable: Array[Villager] = []

func register_enemy(enemy: Enemy):
	enemy_dictionary[enemy.name] = true
	
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
		if quest_on_clear != "":
			UI.instance.quests.change_quest(quest_on_clear)
			
		for villager in villagers_to_enable:
			print("Enabling " + villager.name)
			villager.set_process(true)
			villager.set_physics_process(true)
			villager.set_process_input(true)
			villager.visible = true
		for villager in villagers_to_disable:
			print("Disabling " + villager.name)
			villager.queue_free()
