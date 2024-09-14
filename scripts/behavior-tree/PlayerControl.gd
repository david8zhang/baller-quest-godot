class_name PlayerControl
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	var player_control_fsm = player.player_control_fsm as StateMachine
	player_control_fsm.enable_for_first_time()
	return SUCCESS
