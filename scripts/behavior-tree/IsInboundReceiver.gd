class_name IsInboundReceiver
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var manager = player.get_manager()
	return SUCCESS if player == manager.inbound_receiver else FAILURE