class_name CameraController
extends Node

@onready var camera = $Camera2D as Camera2D
var _target

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.limit_left = -550
	camera.limit_right = 550
	camera.limit_top = -350
	camera.limit_bottom = 1160

func set_target(target):
	_target = target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _target != null:
		camera.global_position = _target.global_position
