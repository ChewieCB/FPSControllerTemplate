extends Node
class_name State
# State interface to use in Hierarchical State Machines. The lowest leaf tries
# to handle callbacks, and if it can't, it delegates the work to its parent
#
# It's up to the user to call the parent state's functions, e.g.
# `_parent.physics_process(delta)`
#
# Use State as a child of a StateMachine node

onready var _state_machine = _get_state_machine(self)
onready var _actor = _state_machine.actor

# Using the same class, i.e. State as a type hint causes a memory leak in Godot 3.2
var _parent = null


func _ready():
	yield(owner, "ready")
	var parent = get_parent()
	_actor = _state_machine.actor
	if not parent.is_in_group("state_machine"):
		_parent = parent


func unhandled_input(_event: InputEvent):
	pass


func process(_delta: float):
	pass


func physics_process(_delta: float):
	pass


func enter(_msg := {}):
	pass


func exit():
	pass


func _get_state_machine(node: Node):
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
