class_name IsScreenActive
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	return SUCCESS if curr_player.is_screen_active else FAILURE