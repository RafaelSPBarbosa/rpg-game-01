extends Node3D
class_name Audio_Manager

static var instance: Audio_Manager = null
func _init() -> void: instance = self

@onready var music_cozy : AudioStreamPlayer3D = $MusicCozy
@onready var music_boss : AudioStreamPlayer3D = $MusicBoss

func start_boss_fight():
	music_cozy.stop()
	music_boss.play()
