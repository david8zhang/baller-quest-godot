class_name OffensiveStateMachine
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	player.linear_damp = 100
	player.linear_velocity = Vector2.ZERO
	return SUCCESS
