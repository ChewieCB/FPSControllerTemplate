extends State
# State for when there is no movement input
# Supports triggering jump after the player has started to fall

var skin
var audio_player
var velocity := Vector3.ZERO


func enter(_msg: Dictionary = {}):
#	audio_player = _actor.audio_player
#	skin = _actor.skin
	#
	_parent.velocity = Vector3.ZERO
	_parent.enter()
	#
#	skin.transition_to(skin.States.IDLE)
#	yield(audio_player.audio_player, "finished")
#	audio_player.stop_audio()


func unhandled_input(event: InputEvent):
	_parent.unhandled_input(event)


func physics_process(delta: float):
	_parent.physics_process(delta)
	if _actor.is_on_floor():
		if _parent.input_direction != Vector3.ZERO:
			# Walking
			for _input in ["p1_move_forward", "p1_move_left", "p1_move_backward", "p1_move_right"]:
				if Input.is_action_pressed(_input):
					_state_machine.transition_to("Movement/Walking")
		elif _parent.velocity.y < -0.1:
			_state_machine.transition_to(
				"Movement/Falling",
				{"was_on_floor": _actor.is_on_floor()}
			)


func exit():
	_parent.exit()
