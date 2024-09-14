class_name IsInbounder
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var manager = player.get_manager()
	return SUCCESS if player == manager.inbounder else FAILURE