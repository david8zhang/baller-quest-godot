class_name Court
extends Node2D

@onready var sprite_2d = $Sprite2D as Sprite2D

func get_size():
	return sprite_2d.texture.get_size()
