class_name IsInbounder
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as Player

	var game = blackboard.get_value("Game") as Game
	var players = game.cpu_manager.players if player.side == Game.SIDE.CPU else game.player_manager.players
	var min_dist = INF
	var player_closest_to_ball = null
	var ball = game.ball

	if ball == null:
		return FAILURE

	for p in players:
		var dist_to_ball = p.global_position.distance_to(ball.global_position)
		if dist_to_ball < min_dist:
			dist_to_ball = min_dist
			player_closest_to_ball = p
	
	# Inbound passer is player closest to the ball
	return SUCCESS if player == player_closest_to_ball else FAILURE