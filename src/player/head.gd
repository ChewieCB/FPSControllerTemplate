extends Spatial

var min_look_angle = -60.0
var max_look_angle = 80.0

var is_using_controller = false

var mouse_delta = Vector2.ZERO
onready var actor = get_parent()

var camera_rotation = Vector3.ZERO


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	# Get pitch and yaw values from relative mouse/joystick movement
	if event is InputEventMouseMotion:
		is_using_controller = false
		mouse_delta = event.relative
		if not GlobalFlags.CAMERA_INVERT_X:
			mouse_delta.x *= -1
		if not GlobalFlags.CAMERA_INVERT_Y:
			mouse_delta.y *= -1
	elif event is InputEventJoypadMotion:
		is_using_controller = true


func _process(delta):
	if GlobalFlags.CAMERA_CONTROLS_ACTIVE:
		#
		if is_using_controller:
			mouse_delta = Vector2(
				Input.get_action_strength("p1_camera_right") - Input.get_action_strength("p1_camera_left"),
				Input.get_action_strength("p1_camera_up") - Input.get_action_strength("p1_camera_down")
			) * 10
			
			# Camera inversions
			if not GlobalFlags.CAMERA_INVERT_X:
				mouse_delta.x *= -1
			if GlobalFlags.CAMERA_INVERT_Y:
				mouse_delta.y *= -1
		
		#
		var yaw_dir = mouse_delta.x
		var pitch_dir = mouse_delta.y
		
		# Rotate the camera pivot accordingly
		camera_rotation = Vector3(yaw_dir, pitch_dir, 0) * GlobalFlags.LOOK_SENSITIVITY * delta
		rotation_degrees.y += camera_rotation.x

		rotation_degrees.x += camera_rotation.y
		rotation_degrees.x = clamp(rotation_degrees.x, min_look_angle, max_look_angle)
		
		mouse_delta = Vector2.ZERO

