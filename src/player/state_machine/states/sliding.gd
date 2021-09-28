extends State

signal exit_slide

export var max_speed = 55
export var move_speed = 45
export var h_acceleration = 6
var gravity = 90

var skin
var audio_player
var velocity := Vector3.ZERO

onready var slide_timer = Timer.new()
export var slide_time = 0.8


func enter(_msg: Dictionary = {}):
#	audio_player = _actor.audio_player
#	skin = _actor.skin	
	_actor.body_collider.disabled = true
	_actor.tween.interpolate_property(
		_actor.head,
		"translation:y",
		2.5, 1,
		0.2,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
#	_actor.tween.interpolate_property(
#		_actor.camera,
#		"fov",
#		70, 60,
#		0.2,
#		Tween.TRANS_SINE,
#		Tween.EASE_IN_OUT
#	)
	_actor.tween.start()
	
	_parent.enter()
	_parent.max_speed = max_speed
	_parent.move_speed = move_speed
	_parent.gravity = gravity
	
	if not self.is_connected("exit_slide", _parent, "_start_slide_cooldown"):
		self.connect("exit_slide", _parent, "_start_slide_cooldown")
	
#	audio_player.transition_to(audio_player.States.CHARGE)
#	skin.transition_to(skin.States.CHARGE)
	
	slide_timer.one_shot = true
	slide_timer.wait_time = slide_time
	if not slide_timer.is_connected("timeout", self, "_on_slide_timer_timeout"):
		slide_timer.connect("timeout", self, "_on_slide_timer_timeout")
	if not slide_timer in get_children():
		add_child(slide_timer)
		slide_timer.start()


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
			elif Input.is_action_just_released("p1_sprint"):
				_determine_exit_state()
			elif Input.is_action_just_released("p1_slide"):
				_determine_exit_state()
		# Falling
		else:
			if _parent.velocity.y < 0:
				_state_machine.transition_to(
					"Movement/Falling",
					{"was_on_floor": true}
				)


func exit():
	_actor.body_collider.disabled = false
	_actor.tween.interpolate_property(
		_actor.head,
		"translation:y",
		1, 2.5,
		0.3,
		Tween.TRANS_BACK,
		Tween.EASE_IN
	)
#	_actor.tween.interpolate_property(
#		_actor.camera,
#		"fov",
#		60, 70,
#		0.2,
#		Tween.TRANS_SINE,
#		Tween.EASE_IN_OUT
#	)
	_actor.tween.start()
#	audio_player.stop_audio()
	_parent.exit()


func _determine_exit_state():
	if not slide_timer.is_stopped():
		yield(get_tree().create_timer(0.2), "timeout")
	if Input.is_action_pressed("p1_sprint"):
		_state_machine.transition_to("Movement/Sprinting")
	elif Input.is_action_pressed("p1_slide"):
		_state_machine.transition_to("Movement/Crouching")
	else:
		_state_machine.transition_to("Movement/Walking")


func _on_slide_timer_timeout():
	remove_child(slide_timer)
	emit_signal("exit_slide")
	_determine_exit_state()
