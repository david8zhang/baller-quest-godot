class_name DefendState
extends State

func enter(msg:={}):
	var anim_name = "onball-defend-front"
	var player = entity as Player
	if player.side == Game.SIDE.CPU:
		anim_name = "cpu-" + anim_name
	anim_sprite.play(anim_name)
