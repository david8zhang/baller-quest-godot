class_name PlayerCourtPlayer
extends CourtPlayer

@onready var player_control_fsm: StateMachine = $PlayerControlFSM
var is_switching

func is_selected():
	return player_manager.selected_player == self
	

func handle_input(_input: InputEvent):
	if is_selected():
		# Offensive controls
		if has_ball and game.ball != null:
			if Input.is_action_pressed("shoot_ball"):
				if is_within_layup_range():
					player_control_fsm.transition_to("LayupState", {})
				else:
					player_control_fsm.transition_to("ShootState", {})
			elif Input.is_action_just_pressed("pass"):
				if pass_target != null:
					player_control_fsm.transition_to("PassState", {})
			elif Input.is_action_just_pressed("call_for_screen"):
				if super.can_call_for_screen():
					var screen_setter = player_manager.get_screener_for_player(self)
					screen_setter.setup_screening_state()
		# Defensive controls
		elif Input.is_action_just_pressed("pass"):
			var switch_target = player_manager.switch_target
			if switch_target != null and !is_switching:
				switch_target.is_switching = true
				deselect()
				switch_target.select()
				player_manager.selected_player = switch_target

				# Add delay on switching
				var timer = Timer.new()
				timer.autostart = true
				timer.wait_time = 0.1
				timer.one_shot = true
				var callable = Callable(self, "on_switch_complete").bind(switch_target, timer)
				add_child(timer)
				timer.connect("timeout", callable)

func on_switch_complete(target, timer):
	target.is_switching = false
	timer.queue_free()


func update_switch_target(switch_target: CourtPlayer):
	if player_manager.switch_target != null:
		player_manager.switch_target.target_highlight.visible = false
	player_manager.switch_target = switch_target
	player_manager.switch_target.target_highlight.visible = true	


func on_completed_pass(custom_cb):
	super.on_completed_pass(custom_cb)
	player_control_fsm.transition_to("IdleState", {})


func handle_ball_collision(ball: Ball):
	if super.check_can_gain_possession():
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER
		player_manager.switch_to_player(self)
		player_control_fsm.transition_to("IdleState", {})
	super.handle_ball_collision(ball)
	
func on_jump_complete(custom_jump_complete_cb: Callable):
	self.set_gravity_scale(0)
	self.linear_velocity = Vector2(0, 0)
	custom_jump_complete_cb.call()


func select():
	target_highlight.visible = false
	highlight.visible = true


func deselect():
	target_highlight.visible = false
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
