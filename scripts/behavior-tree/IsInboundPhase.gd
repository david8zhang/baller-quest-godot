class_name IsInboundPhase
extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var manager = player.get_manager() as Manager
	return SUCCESS if manager.curr_team_phase == Manager.TEAM_PHASE.INBOUNDING else FAILURE