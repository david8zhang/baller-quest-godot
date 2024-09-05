class_name IsBallLoose
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var ball = player.game.ball as Ball
	return SUCCESS if ball != null and ball.curr_poss_status == Ball.POSS_STATUS.LOOSE else FAILURE
