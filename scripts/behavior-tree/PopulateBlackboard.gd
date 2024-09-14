class_name PopulateBlackboard
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as CourtPlayer
	var game = player.game as Game
	blackboard.set_value("Game", game)
	return SUCCESS