class_name DefendState
extends State

func enter(msg:={}):
	var anim_name = "onball-defend-front"
	var player = entity as Player
	if player.side == Game.SIDE.CPU:
		anim_name = "cpu-" + anim_name
	anim_sprite.play(anim_name)


func update(_delta: float):
	var player = entity as Player
	var game = player.game as Game
	var player_to_defend = player.get_player_to_defend() as Player
	if !player_to_defend.has_ball:
		player._state_machine.transition_to("IdleState")
