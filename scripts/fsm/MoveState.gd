class_name MoveState
extends State

const SPEED = 300.0
var dest_point: Vector2

func enter(msg:={}):
	dest_point = msg["dest_point"]

func _physics_process(delta):
	pass
#	var player = entity as Player
#	if dest_point != null:
#		var angle_between = player.global_position.angle_to(dest_point)
#		var x_dir = cos(angle_between)
#		var y_dir = sin(angle_between)
#		var velocity = Vector2(x_dir, y_dir) * SPEED
#		player.global_position += velocity * delta
		
