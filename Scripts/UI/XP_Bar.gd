extends Control
class_name XP_Bar

@onready var bar: Panel = $Bar
@onready var label = $Label

func _ready():
	update_bar()

func update_bar():
	var xp_percentage : float = float(Player.instance.xp) / float(Player.instance.xp_by_levels[Player.instance.level - 1])
	var pixels = (size.x / 2) * xp_percentage 
	bar.get_theme_stylebox("panel").border_width_right = (size.x / 2) - pixels
	
	label.text = "Lvl " + str(Player.instance.level)
