class_name TakePossessionOfBall
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as CourtPlayer
	player.linear_damp = 0
	var game = blackboard.get_value("Game") as Game

	# Move towards the ball
	var ball = game.ball
	if ball == null:
		return FAILURE

	var dir = (ball.global_position - player.global_position).normalized()
	player.linear_velocity = dir * CourtPlayer.SPEED

	# Player running animation
	var anim_name = "run-front" if abs(dir.x) < 0.5 else "run-side"
	var anim_sprite = player.anim_sprite as AnimatedSprite2D
	if player.side == Game.SIDE.CPU:
		anim_name = "cpu-" + anim_name
	anim_sprite.play(anim_name)
	anim_sprite.flip_h = dir.x < 0

	return SUCCESS