extends State
# State for when the player is jumping

export var jump_velocity = 35

var audio_player
var skin


func enter(_msg: Dictionary = {}):
#	audio_player = _actor.audio_player
#	skin = _actor.skin
	#
	_parent.enter()
#	_parent.velocity.x *= 2
#	_parent.velocity.z *= 2
	_parent.velocity += Vector3(0, jump_velocity, 0)
	#
#	audio_player.transition_to(audio_player.States.JUMP)
#	skin.transition_to(skin.States.JUMP)


func unhandled_input(_event: InputEvent):
	pass


func physics_process(delta: float):
	_parent.physics_process(delta)
	if _actor.is_on_ceiling():
		_parent.velocity.y = 0
	# Transition to Falling at peak of jump
	if _parent.velocity.y <= 0:
		_state_machine.transition_to(
				"Movement/Falling",
				{"was_on_floor": false}
			)


func exit():
	_parent.exit()
