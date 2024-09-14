class_name GoToInboundPosition
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var manager = player.get_manager()
	var inbound_position = manager.get_inbounder_position()
	player.move_to_position(inbound_position)
	return SUCCESS