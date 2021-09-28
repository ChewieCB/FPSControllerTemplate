extends State

export var max_speed = 55
export var move_speed = 40
export var h_acceleration = 6
var gravity = 90

var skin
var audio_player
var velocity := Vector3.ZERO


func enter(_msg: Dictionary = {}):
#	audio_player = _actor.audio_player
#	skin = _actor.skin
	
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.gravity = gravity
	
#	audio_player.transition_to(audio_player.States.CHARGE)
#	skin.transition_to(skin.States.CHARGE)


func physics_process(delta: float):
	_parent.physics_process(delta)
	
	# Idle
	if _parent.input_direction == Vector3.ZERO:
		_state_machine.transition_to("Movement/Idle")
	else:
		if _actor.is_on_floor():
			# Jumping
			if Input.is_action_pressed("p1_jump"):
				_state_machine.transition_to("Movement/Jumping")
			elif Input.is_action_just_pressed("p1_slide") and \
			Input.is_action_pressed("p1_slide") and \
			_parent.slide_cooldown_timer.is_stopped():
				_state_machine.transition_to("Movement/Sliding")
			elif Input.is_action_just_released("p1_sprint"):
				_state_machine.transition_to("Movement/Walking")
		# Falling
		else:
			if _parent.velocity.y < 0:
				_state_machine.transition_to(
					"Movement/Falling",
					{"was_on_floor": true}
				)


func exit():
#	audio_player.stop_audio()
	_parent.exit()

