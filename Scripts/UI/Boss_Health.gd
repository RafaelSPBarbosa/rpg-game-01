extends Control
class_name Boss_Health

@onready var bar: Panel = $Bar

func _ready():
	modulate.a = 0.0

func update_bar():
	var health_percentage : float = Boss.instance.health / Boss.instance.max_health
	var pixels = (bar.size.x) * health_percentage 
	bar.get_theme_stylebox("panel").border_width_right = (bar.size.x) - pixels
