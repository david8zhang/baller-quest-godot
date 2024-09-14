class_name IsDefendingBallHandler
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var curr_player = actor as CourtPlayer
	var player_to_defend = curr_player.get_player_to_defend()
	return SUCCESS if player_to_defend != null and player_to_defend.has_ball else FAILURE
