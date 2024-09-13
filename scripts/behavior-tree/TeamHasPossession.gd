class_name TeamHasPossession
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as Player
	var game = blackboard.get_value("Game") as Game
	var ball = game.ball
	if ball != null:
		if player.side == Game.SIDE.CPU:
			return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.CPU else FAILURE
		else:
			return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER else FAILURE
	return FAILURE
