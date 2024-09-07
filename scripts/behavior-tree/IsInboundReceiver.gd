class_name IsInboundReceiver
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	return SUCCESS if player.player_type == Game.PLAYER_TYPE.POINT_GUARD else FAILURE