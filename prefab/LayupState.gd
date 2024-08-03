class_name LayupState
extends State

func enter(msg := {}):
	var player = entity as Player
	player.anim_sprite.stop()
	player.anim_sprite.animation = "layup-front"
	player.anim_sprite.frame = 0
