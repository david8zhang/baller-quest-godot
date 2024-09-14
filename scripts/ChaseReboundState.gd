class_name ChaseReboundState
extends State

const REBOUND_RANGE = 300

func exit():
	var curr_player = entity as CourtPlayer
	curr_player.linear_damp = 100
	
func physics_update(_delta: float):
	var curr_player = entity as CourtPlayer	
	var ball = curr_player.game.ball as Ball
	curr_player.linear_damp = 0
	if ball != null and is_within_rebound_range():
		var ball_position = ball.global_position
		var dir = (ball_position - curr_player.global_position).normalized() as Vector2
		curr_player.linear_velocity = dir * CourtPlayer.SPEED
		
		var anim_name = "run-front" if abs(dir.x) < 0.5 else "run-side"
		if curr_player.side == Game.SIDE.CPU:
			anim_name = "cpu-" + anim_name
		anim_sprite.play(anim_name)
		anim_sprite.flip_h = dir.x < 0
	else:
		curr_player.player_control_fsm.transition_to("IdleState")


func is_within_rebound_range():
	var curr_player = entity as CourtPlayer
	var game = curr_player.game as Game
	var ball = game.ball as Ball
	return curr_player.global_position.distance_to(ball.global_position) <= REBOUND_RANGE
