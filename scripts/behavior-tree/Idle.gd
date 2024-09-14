class_name Idle
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard):
	var player = actor as CourtPlayer
	player.linear_damp = 100
	var anim_name = "dribble-idle" if player.has_ball else "idle-front"
	if player.side == Game.SIDE.CPU:
		anim_name = "cpu-" + anim_name
	player.anim_sprite.play(anim_name)
	return SUCCESS
