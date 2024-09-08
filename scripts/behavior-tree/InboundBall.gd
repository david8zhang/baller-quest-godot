class_name InboundBall
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as Player
	return SUCCESS