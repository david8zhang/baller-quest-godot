class_name Hoop
extends StaticBody2D

@onready var net = $Net as Sprite2D

func disable_rim_collider():
	set_collision_mask_value(3, true)
	set_collision_layer_value(3, true)
	
func enable_rim_collider():
	set_collision_mask_value(2, true)
	set_collision_layer_value(2, true)

func _process(delta):
	net.z_index = 2000
