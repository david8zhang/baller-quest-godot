class_name GoToReceiveInboundPosition
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var manager = player.get_manager()
	player.move_to_position(manager.get_inbound_receiver_position())
	return SUCCESS