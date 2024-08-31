class_name Hoop
extends StaticBody2D

@onready var net = $Net as Sprite2D
@onready var backboard = $Backboard as Sprite2D
@onready var back_sprite = $BackSprite as Sprite2D
@onready var point_detector = $PointDetector as Area2D


func _ready():
	net.z_index = 2000
	back_sprite.modulate = Color(1, 1, 1, 0.5)

func display_back():
	net.hide()
	backboard.hide()
	back_sprite.show()

func display_front():
	net.show()
	backboard.show()
	back_sprite.hide()
