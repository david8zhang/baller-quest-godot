class_name IsInbounderOrInboundReceiver
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	if player.player_type == Game.PLAYER_TYPE.POINT_GUARD:
		return SUCCESS
	var manager = player.get_manager()
	return SUCCESS if player == manager.inbounder else FAILURE