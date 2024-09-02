class_name PlayerControl
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as Player
	var player_control_fsm = player._state_machine as StateMachine
	player_control_fsm.enabled = true
