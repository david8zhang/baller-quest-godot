class_name Idle
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard):
	var player = actor as Player
	var anim_name = "idle-front"
	if player.side == Game.SIDE.CPU:
		anim_name = "cpu-" + anim_name
	player.anim_sprite.play(anim_name)
