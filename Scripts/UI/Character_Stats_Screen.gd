extends Control
class_name Character_Stats_Screen

@onready var endurance_label: Attribute_UI = $Panel/endurance_Label
@onready var agility_label: Attribute_UI = $Panel/Agility_Label
@onready var speed_label: Attribute_UI = $Panel/Speed_Label
@onready var luck_label: Attribute_UI = $Panel/Luck_Label
@onready var strength_label: Attribute_UI = $Panel/Strength_Label

@onready var available_points_label = $Panel/Available_Points_Label

@onready var is_open : bool = false

func _ready():
	modulate.a = 0.0
	
func _process(delta):
	if Player.instance.skill_points > 0:
		endurance_label.button.visible = true
		agility_label.button.visible = true
		speed_label.button.visible = true
		luck_label.button.visible = true
		strength_label.button.visible = true
	else:
		endurance_label.button.visible = false
		agility_label.button.visible = false
		speed_label.button.visible = false
		luck_label.button.visible = false
		strength_label.button.visible = false
		
	available_points_label.text = "Available Points: " + str(Player.instance.skill_points)
	endurance_label.label.text = str(Player.instance.endurance)
	agility_label.label.text = str(Player.instance.agility)
	speed_label.label.text = str(Player.instance.speed)
	luck_label.label.text = str(Player.instance.luck)
	strength_label.label.text = str(Player.instance.strength)


func _input(event: InputEvent) -> void:
	if Player.instance.is_alive == false:
		return
		
	#if Player.instance.is_busy == true:
		#return
		
	if event.is_action_pressed("toggle_character_stats_screen"):
		if is_open == false:
			open()
		else:
			close()
		
func open():
	Player.instance.is_busy = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	UI.instance.hide_ui()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	Player.instance.character.idle()
	is_open = true	
	
func close():
	is_open = false
	Player.instance.is_busy = false
	UI.instance.show_ui()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN_OUT)


func _on_close_button_button_down():
	close()
