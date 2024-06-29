class_name PassState
extends State

func enter(msg := {}) -> void:
	var player = entity as Player
	player.pass_ball()
