class_name PassState
extends State

func enter(msg := {}) -> void:
	anim_sprite.play("idle-front")
	var player = entity as Player
	player.pass_ball()
