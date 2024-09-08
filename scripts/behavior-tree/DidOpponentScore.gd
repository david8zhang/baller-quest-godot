class_name DidOpponentScore
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var game = player.game as Game
	var ball = game.ball as Ball
	if ball == null:
		return FAILURE
	else:
		if player.side == Game.SIDE.CPU:
			return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER_JUST_SCORED else FAILURE
		else:
			return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.CPU_JUST_SCORED else FAILURE
