extends State
# Parent state for all movement-related states for the Player
# Holds all of the base movement logic
# Child states can override this states's functions or change its properties
# This keeps the logic grouped in one location

export var max_speed = 35
export var move_speed = 20
export var h_acceleration = 6
export var gravity = 90
export (float, 0.1, 20.0, 0.1) var look_speed = 8

var is_full_contact = false

var h_velocity = Vector3.ZERO
var velocity := Vector3.ZERO

var input_direction := Vector3.ZERO
var move_direction := Vector3.ZERO
var gravity_vector = Vector3()


func enter(msg: Dictionary = {}):
	pass


func physics_process(delta: float):
	# Debug Reset
	if Input.is_action_pressed("reset"):
		if GlobalFlags.PLAYER_CONTROLS_ACTIVE:
			get_tree().reload_current_scene()
	elif Input.is_action_pressed("quit"):
		GlobalFlags.PLAYER_CONTROLS_ACTIVE = true
		get_tree().quit()
	
	# Movement
	
#	if GlobalFlags.PLAYER_CONTROLS_ACTIVE:
	input_direction = get_input_direction()
#	else:
#		input_direction = Vector3.ZERO
	
	move_direction = calculate_movement_direction(input_direction, delta)
	
	# Get the current gravity vector
	if _actor.ground_check.is_colliding():
		is_full_contact = true
	else:
		is_full_contact = false
	
	if not _actor.is_on_floor():
		gravity_vector = Vector3.DOWN * gravity
	elif _actor.is_on_floor() and is_full_contact:
		gravity_vector = -_actor.get_floor_normal() * gravity
	else:
		gravity_vector = -_actor.get_floor_normal()
	
	velocity = calculate_velocity(velocity, move_direction, delta)
	
	if Input.is_action_just_pressed("p1_jump") and \
	(_actor.is_on_floor() or _actor.ground_check.is_colliding()):
		_state_machine.transition_to("Movement/Jumping")

	velocity = _actor.move_and_slide(velocity, Vector3.UP, true, 4, 0.785398, false)


static func get_input_direction():
	var input_vector =  Vector3(
		Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left"),
		0,
		Input.get_action_strength("p1_move_backward") - Input.get_action_strength("p1_move_forward")
	)
	
	return input_vector


func calculate_movement_direction(input_direction, delta):
	var forwards := Vector3.ZERO
	var right := Vector3.ZERO
	
	# We calculate a move direction vector relative to the head,
	# the basis stores the (right, up, -forwards) vectors of our current
	# head direction.
	forwards = input_direction.z * _actor.head.global_transform.basis.z
	right = input_direction.x * _actor.head.global_transform.basis.x
	move_direction = forwards + right
	
	if move_direction.length() > 1.0:
		move_direction = move_direction.normalized()
		move_direction.y = 0
	
	return move_direction 


func calculate_velocity(velocity_current: Vector3, move_direction: Vector3, delta: float):
	var velocity_new = move_direction * move_speed
	if velocity_new.length() > max_speed:
		velocity_new = velocity_new.normalized() * max_speed
	velocity_new.y = velocity_current.y + gravity_vector.y * delta
	
	return velocity_new


