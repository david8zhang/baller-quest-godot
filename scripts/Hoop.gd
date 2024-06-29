class_name Hoop
extends StaticBody2D

@onready var net = $Net as Sprite2D

func _ready():
	net.z_index = 2000
