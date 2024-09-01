class_name IsPlayer
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as BTreePlayer
	return SUCCESS if player.side == Game.SIDE.PLAYER else FAILURE
