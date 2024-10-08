class_name CourtPlayer
extends RigidBody2D

static var SPEED = 300.0

var screen_size
var pass_target: CourtPlayer
var has_ball: bool = false
var player_name: String = ""
var side: Game.SIDE
var can_gain_possession: bool = true
var player_type: Game.PLAYER_TYPE
var hoop_to_shoot_at: Hoop
var is_jumping: bool = false

# Screen state
var is_setting_screen: bool = false
var is_screen_active: bool = false
var screen_pos

var last_shot_type

@onready var game: Game = get_node("/root/Main") as Game
@onready var player_manager: PlayerManager = get_node("/root/Main/PlayerManager")
@onready var cpu_manager: CPUManager = get_node("/root/Main/CPUManager")
@onready var court: Court = get_node("/root/Main/Court") as Court
@onready var shot_meter = $ShotMeter as ShotMeter
@onready var highlight = $Highlight as Sprite2D
@onready var target_highlight = $TargetHighlight as Sprite2D
@onready var anim_sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var feet_area = $FeetArea as Area2D
@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var navigation_agent_2d = $NavigationAgent2D as NavigationAgent2D


func _ready():
	screen_size = get_viewport_rect().size
	highlight.visible = false
	target_highlight.visible = false
	anim_sprite.scale = Vector2(3, 3)
	highlight.scale = Vector2(
		3 * highlight.scale.x,
		3 * highlight.scale.y
	)
	highlight.position = Vector2(
		anim_sprite.position.x,
		anim_sprite.position.y + 50,
	)
	target_highlight.scale = Vector2(
		3 * target_highlight.scale.x,
		3 * target_highlight.scale.y
	)
	target_highlight.position = Vector2(
		anim_sprite.position.x,
		anim_sprite.position.y + 50,
	)
	feet_area.scale = Vector2(3, 3)
	collision_shape_2d.scale = Vector2(3, 3)


func is_selected():
	return player_manager.selected_player == self


func _physics_process(_delta):
	# Ensure player does not exceed court bounds, unless player is inbounder
	var curr_manager = (cpu_manager as Manager) if side == Game.SIDE.CPU else (player_manager as Manager)
	var is_inbounder = curr_manager.inbounder == self
	if !is_inbounder and !is_jumping:
		var court_y_bounds = court.get_y_bounds()
		var court_x_bounds = court.get_x_bounds()
		global_position.y = clamp(global_position.y, court_y_bounds["upper"], court_y_bounds["lower"])
		global_position.x = clamp(global_position.x, court_x_bounds["left"], court_x_bounds["right"])


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
	if pass_target != null:
		pass_target.target_highlight.visible = false
	pass_target = closest_player
	if has_ball:
		pass_target.target_highlight.visible = true
	

func is_within_layup_range():
	var dist_to_hoop = global_position.distance_to(hoop_to_shoot_at.global_position)
	return dist_to_hoop <= 250


func pass_ball(custom_cb):
	has_ball = false
	var ball = game.ball
	ball.show()
	ball.global_position = self.global_position
	ball.set_gravity_scale(0)
	ball.enable_player_detector()
	pass_target.can_gain_possession = true
	can_gain_possession = false
	var tween = create_tween()
	tween.tween_property(ball, "global_position", pass_target.global_position, 0.5)
	var cb = Callable(self, "on_completed_pass").bind(custom_cb)
	tween.finished.connect(cb)


func on_completed_pass(custom_cb):
	can_gain_possession = true
	if custom_cb != null:
		custom_cb.call()


func check_can_gain_possession():
	var ball = game.ball
	var is_other_team_inbounding = false
	if side == Game.SIDE.CPU:
		is_other_team_inbounding = ball.curr_poss_status == Ball.POSS_STATUS.INBOUND_PASS_PLAYER
	else:
		is_other_team_inbounding = ball.curr_poss_status == Ball.POSS_STATUS.INBOUND_PASS_CPU
	return can_gain_possession and !is_other_team_inbounding


func handle_ball_collision(ball: Ball):
	if check_can_gain_possession():
		target_highlight.visible = false
		can_gain_possession = false
		has_ball = true
		game.ball.hide()
		var prev_ball_poss_status = ball.curr_poss_status
		var prev_ball_poss_side = Game.SIDE.CPU if prev_ball_poss_status == Ball.POSS_STATUS.CPU else Ball.POSS_STATUS.PLAYER
		ball.curr_poss_status = Ball.POSS_STATUS.CPU if side == Game.SIDE.CPU else Ball.POSS_STATUS.PLAYER

		# If possession switched sides
		var curr_manager = player_manager as Manager if side == Game.SIDE.PLAYER else cpu_manager
		var other_manager = cpu_manager as Manager if side == Game.SIDE.PLAYER else player_manager
		if prev_ball_poss_side != side and get_manager().curr_team_phase != Manager.TEAM_PHASE.INBOUNDING:
			curr_manager.curr_team_phase = Manager.TEAM_PHASE.SETTING_UP_OFFENSE
			other_manager.curr_team_phase = Manager.TEAM_PHASE.SETTING_UP_DEFENSE

		ball.disable_player_detector()


func shoot_ball(shot_result: ShotMeter.SHOT_RESULT, arc_duration: float = 1.5, start_position: Vector2 = Vector2(self.position.x, self.position.y - 100)):
	has_ball = false
	var ball = game.ball
	ball.show()
	ball.global_position = start_position
	ball.set_gravity_scale(1)
	ball.disable_player_detector()
	ball.shot_status = shot_result
	ball.curr_poss_status = Ball.POSS_STATUS.SHOOT_UP
	
	if shot_result == ShotMeter.SHOT_RESULT.MAKE:
		var y_diff = hoop_to_shoot_at.net.global_position.y - ball.global_position.y
		create_arc(ball, hoop_to_shoot_at.net.global_position, arc_duration)
	else:
		var x_target_miss_left = randi_range(hoop_to_shoot_at.position.x - 15, hoop_to_shoot_at.position.x - 10)
		var x_target_miss_right = randi_range(hoop_to_shoot_at.position.x + 10, hoop_to_shoot_at.position.x + 15)
		var x_target = x_target_miss_left if randi_range(0, 1) == 0 else x_target_miss_right
		create_arc(ball, Vector2(x_target, hoop_to_shoot_at.global_position.y - 10), arc_duration)
		
	# Create timer to reset shot meter
	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	timer.one_shot = true
	var callable = Callable(self, "reset_shot_meter").bind(timer)
	timer.connect("timeout", callable)
	add_child(timer)


func reset_shot_meter(timer: Timer):
	shot_meter.visible = false
	shot_meter.reset()
	timer.queue_free()


func create_arc(ball: RigidBody2D, dest_position: Vector2, duration_sec: float):
	ball.z_index = hoop_to_shoot_at.net.z_index + 1
	var velocity_x = (dest_position.x - ball.global_position.x) / duration_sec
	var velocity_y = (dest_position.y - ball.global_position.y - 490 * pow(duration_sec, 2)) / duration_sec
	ball.linear_velocity = Vector2(velocity_x, velocity_y)
	
	# Do stuff when ball has reached peak of its arc
	var arc_halfway_timer = Timer.new()
	arc_halfway_timer.wait_time = duration_sec / 2
	arc_halfway_timer.one_shot = true
	arc_halfway_timer.autostart = true
	var ball_reached_apex_cb = Callable(self, "on_ball_reached_apex").bind(ball)
	arc_halfway_timer.connect("timeout", ball_reached_apex_cb)
	add_child(arc_halfway_timer)
	
	# Set a timer to re-enable ball collider if it was disabled
	var on_arc_complete_timer = Timer.new()
	on_arc_complete_timer.wait_time = duration_sec + 0.25
	on_arc_complete_timer.one_shot = true
	on_arc_complete_timer.autostart = true
	var shot_complete_cb = Callable(self, "on_shot_complete").bind(ball, on_arc_complete_timer)
	on_arc_complete_timer.connect("timeout", shot_complete_cb)
	add_child(on_arc_complete_timer)
	

func jump(custom_jump_complete_cb: Callable, jump_apex_cb: Callable, duration_sec: float):
	self.set_gravity_scale(1)
	var velocity_x = 0
	var velocity_y = ((self.position.y - 50) - self.position.y - 490 * pow(duration_sec, 2)) / duration_sec
	self.linear_velocity = Vector2(velocity_x, velocity_y)
	var jump_peak_timer = Timer.new()
	is_jumping = true

	jump_peak_timer.wait_time = duration_sec / 2
	jump_peak_timer.one_shot = true
	jump_peak_timer.autostart = true
	jump_peak_timer.connect("timeout", jump_apex_cb)
	add_child(jump_peak_timer)
	
	var jump_complete_timer = Timer.new()
	jump_complete_timer.wait_time = duration_sec + 0.25
	jump_complete_timer.one_shot = true
	jump_complete_timer.autostart = true
	var jump_complete_cb = Callable(self, "on_jump_complete").bind(custom_jump_complete_cb)
	jump_complete_timer.connect("timeout", jump_complete_cb)
	add_child(jump_complete_timer)
	

func jump_toward(custom_jump_complete_cb: Callable, jump_apex_cb: Callable, duration_sec: float, dest_position: Vector2):
	self.set_gravity_scale(1)
	var velocity_x = (dest_position.x - self.global_position.x) / duration_sec
	var velocity_y = (dest_position.y - self.global_position.y - 490 * pow(duration_sec, 2)) / duration_sec
	self.linear_velocity = Vector2(velocity_x, velocity_y)
	var jump_peak_timer = Timer.new()
	is_jumping = true

	jump_peak_timer.wait_time = duration_sec / 2
	jump_peak_timer.one_shot = true
	jump_peak_timer.autostart = true
	jump_peak_timer.connect("timeout", jump_apex_cb)
	add_child(jump_peak_timer)
	
	var jump_complete_timer = Timer.new()
	jump_complete_timer.wait_time = duration_sec
	jump_complete_timer.one_shot = true
	jump_complete_timer.autostart = true
	var jump_complete_cb = Callable(self, "on_jump_complete").bind(custom_jump_complete_cb)
	jump_complete_timer.connect("timeout", jump_complete_cb)
	add_child(jump_complete_timer)
	
	
func on_jump_complete(custom_jump_complete_cb: Callable):
	is_jumping = false
	self.set_gravity_scale(0)
	self.linear_velocity = Vector2(0, 0)
	custom_jump_complete_cb.call()
	

func on_shot_complete(ball: Ball, timer: Timer):
	if ball.shot_status == ShotMeter.SHOT_RESULT.MAKE:
		var points_scored = 2 if last_shot_type == Game.SHOT_TYPE.TWO_POINTER else 3
		game.scoreboard.add_score(side, points_scored)
		ball.curr_poss_status = Ball.POSS_STATUS.PLAYER_JUST_SCORED
		var didPlayerScore = side == Game.SIDE.PLAYER
		if didPlayerScore:
			cpu_manager.assign_inbounder_and_receiver()
			cpu_manager.curr_team_phase = Manager.TEAM_PHASE.INBOUNDING
			player_manager.curr_team_phase = Manager.TEAM_PHASE.SETTING_UP_DEFENSE
		else:
			player_manager.assign_inbounder_and_receiver()
			player_manager.curr_team_phase = Manager.TEAM_PHASE.INBOUNDING
			cpu_manager.curr_team_phase = Manager.TEAM_PHASE.SETTING_UP_DEFENSE
	ball.enable_player_detector()
	can_gain_possession = true
	timer.queue_free()
	

func on_ball_reached_apex(ball: Ball):
	ball.z_index = hoop_to_shoot_at.net.z_index - 1
	ball.curr_poss_status = Ball.POSS_STATUS.SHOOT_DOWN


func select():
	highlight.visible = true


func deselect():
	highlight.visible = false
	
	
func get_player_to_defend():
	if side == Game.SIDE.PLAYER:
		if player_manager.defensive_assignments.has(player_name):
			var player_to_defend_name = player_manager.defensive_assignments[player_name]
			return cpu_manager.get_player_by_name(player_to_defend_name)
		return null
	elif side == Game.SIDE.CPU:
		if cpu_manager.defensive_assignments.has(player_name):
			var player_to_defend_name = cpu_manager.defensive_assignments[player_name]
			return player_manager.get_player_by_name(player_to_defend_name)
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
	return (cpu_manager as Manager) if side == Game.SIDE.CPU else (player_manager as Manager)

func get_opp_manager() -> Manager:
	return (cpu_manager as Manager) if side == Game.SIDE.PLAYER else (player_manager as Manager)

func get_defender() -> CourtPlayer:
	var opp_manager = get_opp_manager()
	var def_assignments = opp_manager.defensive_assignments as Dictionary
	for opp_player_name in def_assignments.keys():
		var def_assignment_name = def_assignments[opp_player_name] as String
		if def_assignment_name == player_name:
			return opp_manager.get_player_by_name(opp_player_name)
	return null

func setup_screening_state():
	# 1. Set the screen position
	# 2. Set a timer on the screen
	var ball_handler = game.get_ball_handler()
	var defender = ball_handler.get_defender()
	var defender_pos = defender.global_position

	# TODO: Won't work if defender is in the corner, also always screens right
	screen_pos = Vector2(defender_pos.x + 75, defender_pos.y)
	is_setting_screen = true

	var screen_timer = Timer.new()
	screen_timer.wait_time = 5
	screen_timer.one_shot = true
	screen_timer.autostart = true
	var callable = Callable(self, "on_screen_finished").bind(screen_timer)
	screen_timer.connect("timeout", callable)
	add_child(screen_timer)

func on_screen_finished(timer: Timer):
	set_collision_mask_value(1, false)
	is_setting_screen = false
	is_screen_active = false
	screen_pos = null
	timer.queue_free()

func can_call_for_screen() -> bool:
	# Check that the current screener isn't already screening
	var manager = get_manager() as Manager
	var screener = manager.get_screener_for_player(self)
	return !screener.is_setting_screen