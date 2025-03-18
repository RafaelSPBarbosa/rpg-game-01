extends Control
class_name Dialog_Panel

@onready var character_name_label: Label = $Character_Name
@onready var message_label: Label = $Message

@onready var is_visible: bool = false

func _ready():
	modulate.a = 0.0

func start(name: String, message: String):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, .25).set_ease(Tween.EASE_OUT)
	is_visible = true
	UI.instance.hide_ui()
	write(name,message)

func start_or_write(name: String, message: String):
	if is_visible == false:
		start(name,message)
	else:
		write(name,message)

func write(name: String, message: String):
	character_name_label.text = name
	message_label.text = message
	
func end():
	is_visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, .25).set_ease(Tween.EASE_OUT)
	UI.instance.show_ui()
	write("","")
