class_name Court
extends Node2D

@onready var sprite_2d = $Sprite2D as Sprite2D
@onready var game = $".." as Game

func get_size():
	return sprite_2d.texture.get_size()

func get_y_bounds():
	var court_size = get_size()
	var offset = sprite_2d.offset.y
	
	if game.is_flipped:
		return {
			"upper": global_position.y - court_size.y/ 2 - offset,
			"lower": global_position.y + court_size.y / 2 - offset
		}
	else:
		return {
			"upper": global_position.y - court_size.y / 2 + offset,
			"lower": global_position.y + court_size.y / 2 + offset
		}

func get_x_bounds():
	var court_size = get_size()
	return {
		"left": global_position.x - court_size.x / 2,
		"right": global_position.x + court_size.x / 2
	}
