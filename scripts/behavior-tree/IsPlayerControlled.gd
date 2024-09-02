class_name IsPlayerControlled
extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as Player
	return SUCCESS if player.is_selected() else FAILURE