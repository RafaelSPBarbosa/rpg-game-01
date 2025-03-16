extends Control
class_name Quest_System

@onready var current_quest: Label = $Current_Quest

func change_quest(description: String):
	current_quest.text = "- " + description
