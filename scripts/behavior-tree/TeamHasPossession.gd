class_name TeamHasPossession
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var ball = player.game.ball as Ball
	if ball != null:
		if player.side == Game.SIDE.CPU:
			return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.CPU else FAILURE
		else:
			return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER else FAILURE
	return FAILURE