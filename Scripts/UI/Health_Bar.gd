extends Control
class_name Health_Bar

@onready var bar: Panel = $Bar

func update_bar():
	var health_percentage : float = Player.instance.health / Player.instance.max_health
	var pixels = (size.x / 2) * health_percentage 
	bar.get_theme_stylebox("panel").border_width_right = (size.x / 2) - pixels
