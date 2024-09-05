class_name ChaseRebound
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as Player	
	curr_player.linear_damp = 0
	var ball = curr_player.game.ball as Ball
	if ball != null:
		var ball_position = ball.global_position
		var dir = (ball_position - curr_player.global_position).normalized() as Vector2
		curr_player.linear_velocity = dir * Player.SPEED

		var anim_name = "run-front" if abs(dir.x) < 0.5 else "run-side"
		var anim_sprite = curr_player.anim_sprite as AnimatedSprite2D
		if curr_player.side == Game.SIDE.CPU:
			anim_name = "cpu-" + anim_name
		anim_sprite.play(anim_name)
		anim_sprite.flip_h = dir.x < 0
	