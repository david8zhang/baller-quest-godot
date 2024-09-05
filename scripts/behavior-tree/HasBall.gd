class_name HasBall
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	return SUCCESS if player.has_ball else FAILURE