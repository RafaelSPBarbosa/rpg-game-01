extends Control
class_name UI

static var instance: UI = null
func _init() -> void: instance = self

@onready var dialog_panel: Dialog_Panel = $Dialog_Panel
@onready var quests: Quest_System = $Quests
@onready var health: Health_Bar = $Health
