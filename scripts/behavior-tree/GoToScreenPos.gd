class_name GoToScreenPos
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	curr_player.move_to_position(curr_player.screen_pos)
	return SUCCESS