class_name ReceivePassState
extends State

func enter(msg := {}):
	var pass_source = msg["pass_source"]
	if anim_sprite.animation != "receive-pass-front":
		anim_sprite.play("receive-pass-front")
