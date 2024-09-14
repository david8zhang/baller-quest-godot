class_name OpponentJustScored
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as CourtPlayer
	var game = blackboard.get_value("Game") as Game
	var ball = game.ball
	if player.side == Game.SIDE.CPU:
		return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.PLAYER_JUST_SCORED else FAILURE
	else:
		return SUCCESS if ball.curr_poss_status == Ball.POSS_STATUS.CPU_JUST_SCORED else FAILURE