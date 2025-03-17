extends Node
class_name CharacterSkin

@onready var animation_tree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
func idle():
	state_machine.travel("Idle")
	
func move():
	state_machine.travel("Move")
	
func attack():
	state_machine.start("Attack")
	
func take_damage():
	state_machine.travel("Take Damage")
	
func die():
	state_machine.travel("Die")
	
func talk():
	state_machine.start("Talk")
