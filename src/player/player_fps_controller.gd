extends KinematicBody

onready var state_machine = $StateMachine

onready var head = $Head
onready var camera = $Head/Camera

onready var body_collider = $BodyCollision
onready var feet_collider = $FeetCollision

onready var ground_check = $GroundCheck

onready var audio_player = null
onready var skin = null
onready var tween = $Tween
