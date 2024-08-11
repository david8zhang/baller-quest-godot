class_name GameCamera
extends Camera2D

func focus_on(node: Node2D):
	reparent(node)
	position = Vector2(0, 0)
