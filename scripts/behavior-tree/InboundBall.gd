class_name InboundBall
extends ActionLeaf

var is_inbounding = false
var is_complete = false

func tick(actor: Node, _blackboard: Blackboard):
	if !is_inbounding:
		is_inbounding = true
		var player = actor as Player
		player.linear_velocity = Vector2.ZERO
		var manager = player.get_manager()
		var inbound_receiver = manager.inbound_receiver
		if inbound_receiver == null:
			return FAILURE
		play_pass_animation(player, inbound_receiver)
	return SUCCESS if is_complete else RUNNING


func play_pass_animation(player: Player, pass_target: Player):
	var anim_sprite = player.anim_sprite as AnimatedSprite2D
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
	var on_pass_frame_cb = Callable(self, "_on_pass_anim_frame").bind(player, pass_target)
	anim_sprite.frame_changed.connect(on_pass_frame_cb)


func _on_pass_anim_frame(player: Player, inbound_receiver: Player):
	var anim_sprite = player.anim_sprite
	var ball = player.game.ball as Ball
	if anim_sprite.frame == 3:
		player.pass_target = inbound_receiver
		ball.curr_poss_status = Ball.POSS_STATUS.INBOUND_PASS
		var on_pass_complete_cb = Callable(self, "on_pass_complete").bind(player)
		player.pass_ball(on_pass_complete_cb)
		anim_sprite.frame_changed.disconnect(_on_pass_anim_frame)

func on_pass_complete(player: Player):
	var manager = player.get_manager()
	manager.on_inbound_complete()
	is_complete = true
