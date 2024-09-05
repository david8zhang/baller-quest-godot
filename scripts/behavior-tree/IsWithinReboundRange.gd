class_name IsWithinReboundRange
extends ConditionLeaf

const REBOUND_RANGE = 300

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var ball = player.game.ball as Ball
	if ball != null:
		var distance_to_ball = player.global_position.distance_to(ball.global_position)
		return SUCCESS if distance_to_ball <= REBOUND_RANGE else FAILURE
	else:
		return FAILURE