class_name ChaseReboundState
extends State

func exit():
	var curr_player = entity as Player
	curr_player.linear_damp = 100
	
func physics_update(_delta: float):
	var curr_player = entity as Player	
	var ball = curr_player.game.ball as Ball
	curr_player.linear_damp = 0
	if ball != null:
		var ball_position = ball.global_position
		var dir = (ball_position - curr_player.global_position).normalized() as Vector2
		curr_player.linear_velocity = dir * Player.SPEED
		
		var anim_name = "run-front" if abs(dir.x) < 0.5 else "run-side"
		if curr_player.side == Game.SIDE.CPU:
			anim_name = "cpu-" + anim_name
		anim_sprite.play(anim_name)
		anim_sprite.flip_h = dir.x > 0
	else:
		curr_player._state_machine.transition_to("IdleState")
