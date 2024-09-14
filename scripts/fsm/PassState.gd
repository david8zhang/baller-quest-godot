class_name PassState
extends State

func enter(_msg := {}) -> void:
	var player = entity as CourtPlayer
	player.linear_velocity = Vector2.ZERO
	var pass_target = player.pass_target
	var pass_target_pos = pass_target.global_position
	var player_pos = player.global_position
	var x_diff = abs(pass_target_pos.x - player_pos.x)
	
	# Determine whether to play side-pass animation or vertical-pass animation
	var pass_axis = "vertical"
	if x_diff > 50:
		pass_axis = "horizontal"
	
	if pass_axis == "vertical":
		if pass_target_pos.y > player_pos.y:
			anim_sprite.play("pass-front")
		else:
			anim_sprite.play("pass-back")
	elif pass_axis == "horizontal":
		if pass_target_pos.x > player_pos.x:
			anim_sprite.flip_h = false
		else:
			anim_sprite.flip_h = true
		anim_sprite.play("pass-side")
	anim_sprite.frame_changed.connect(_on_pass_anim_frame)


func _on_pass_anim_frame():
	var player = entity as CourtPlayer
	if anim_sprite.frame == 3:
		player.pass_ball(null)
		anim_sprite.frame_changed.disconnect(_on_pass_anim_frame)
