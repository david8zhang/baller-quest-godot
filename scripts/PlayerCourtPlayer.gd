class_name PlayerCourtPlayer
extends CourtPlayer

@onready var player_control_fsm: StateMachine = $PlayerControlFSM

func is_selected():
	return player_manager.selected_player == self


func update_pass_target(velocity: Vector2):
	var src_position = global_position + velocity
	var closest_player
	var min_dist = INF
	for player in player_manager.players:
		if player != self:
			var dist = src_position.distance_to(player.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_player = player
	pass_target = closest_player
	

func handle_input(_input: InputEvent):
	if is_selected() and has_ball and game.ball != null:
		if Input.is_action_pressed("shoot_ball"):
			if is_within_layup_range():
				player_control_fsm.transition_to("LayupState", {})
			else:
				player_control_fsm.transition_to("ShootState", {})
		if Input.is_action_just_pressed("pass"):
			if pass_target != null:
				player_control_fsm.transition_to("PassState", {})



func on_completed_pass(custom_cb):
	super.on_completed_pass(custom_cb)
	player_control_fsm.transition_to("IdleState", {})


func handle_ball_collision(ball: Ball):
	if self.can_gain_possession:
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER
		player_manager.switch_to_player(self)
		player_control_fsm.transition_to("IdleState", {})
	super.handle_ball_collision(ball)
	
func on_jump_complete(custom_jump_complete_cb: Callable):
	self.set_gravity_scale(0)
	self.linear_velocity = Vector2(0, 0)
	custom_jump_complete_cb.call()
	

func on_shot_complete(ball: Ball, timer: Timer):
	if ball.shot_status == ShotMeter.SHOT_RESULT.MAKE:
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER_JUST_SCORED
		cpu_manager.assign_inbounder_and_receiver()
	super.on_shot_complete(ball, timer)


func select():
	player_manager.camera.reparent(self)
	highlight.visible = true


func deselect():
	highlight.visible = false
	
	
func get_player_to_defend():
	if player_manager.defensive_assignments.has(player_name):
		var player_to_defend_name = player_manager.defensive_assignments[player_name]
		return cpu_manager.get_player_by_name(player_to_defend_name)
	return null
		

func move_to_position(dest_position: Vector2):
	var dir = (dest_position - global_position).normalized()
	linear_velocity = dir * CourtPlayer.SPEED
	linear_damp = 0
	
	# Player running animation
	var run_anim_name = ""
	if has_ball:
		run_anim_name = "dribble-front" if abs(dir.x) < 0.5 else "dribble-side"
	else:
		run_anim_name = "run-front" if abs(dir.x) < 0.5 else "run-side"
	if side == Game.SIDE.CPU:
		run_anim_name = "cpu-" + run_anim_name
	anim_sprite.play(run_anim_name)
	anim_sprite.flip_h = dir.x < 0

func get_manager() -> Manager:
	return player_manager

func _on_main_on_game_ready():
	hoop_to_shoot_at = game.hoop_1
