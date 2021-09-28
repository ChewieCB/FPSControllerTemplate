extends Node
class_name StateMachine

signal transitioned(state_path)


export (NodePath) var initial_state = NodePath() 

onready var state = get_node(initial_state) setget set_state
onready var _state_name = state.name
onready var actor = get_parent()


func _init():
	add_to_group("state_machine")


func _ready():
	yield(owner, "ready")
	state.enter()


func _unhandled_input(event):
	state.unhandled_input(event)


func _process(delta):
	state.process(delta)


func _physics_process(delta):
	state.physics_process(delta)


func transition_to(target_state_path: String, msg: Dictionary = {}):
	if not has_node(target_state_path):
		return
	
	var target_state := get_node(target_state_path)
	
	state.exit()
	self.state = target_state
	state.enter(msg)
	emit_signal("transitioned", target_state_path)


func set_state(value: State):
	state = value
	_state_name = state.name
