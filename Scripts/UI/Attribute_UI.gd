extends Control
class_name Attribute_UI

@onready var button: Button = $Button
@onready var label: Label = $Label

@export var attribute: String = ""

func _on_button_button_down():
	if Player.instance.skill_points <= 0:
		return
	
	Player.instance.skill_points -= 1
		
	if attribute == "endurance":
		Player.instance.endurance += 1

	if attribute == "agility":
		Player.instance.agility += 1
		
	if attribute == "speed":
		Player.instance.speed += 1
		
	if attribute == "luck":
		Player.instance.luck += 1
		
	if attribute == "strength":
		Player.instance.strength += 1
