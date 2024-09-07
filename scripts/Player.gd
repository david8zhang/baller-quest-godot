class_name Player
extends RigidBody2D

static var SPEED = 300.0

var screen_size
var pass_target: Player
var has_ball: bool = false
var player_name: String = ""
var side
var can_gain_possession: bool = true
var player_type: Game.PLAYER_TYPE

var last_shot_type

@onready var game: Game = get_node("/root/Main") as Game
@onready var player_manager: PlayerManager = get_node("/root/Main/PlayerManager")
@onready var cpu_manager: CPUManager = get_node("/root/Main/CPUManager")
@onready var hoop: Hoop = get_node("/root/Main/Hoop1") as Hoop
@onready var court: Court = get_node("/root/Main/Court") as Court
@onready var shot_meter = $ShotMeter as ShotMeter
@onready var highlight = $Highlight
@onready var anim_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var player_control_fsm: StateMachine = $PlayerControlFSM
@onready var feet_area = $FeetArea as Area2D
@onready var collision_shape_2d = $CollisionShape2D

@export var ball_scene: PackedScene


func _ready():
	screen_size = get_viewport_rect().size
	highlight.visible = false
	anim_sprite.scale = Vector2(3, 3)
	highlight.scale = Vector2(
		2 * highlight.scale.x,
		2 * highlight.scale.y
	)
	highlight.position = Vector2(
		anim_sprite.position.x,
		anim_sprite.position.y + 40,
	)
	feet_area.scale = Vector2(3, 3)
	collision_shape_2d.scale = Vector2(3, 3)


func is_selected():
	return player_manager.selected_player == self


func _physics_process(delta):
	# Ensure player does not exceed court bounds
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
	if pass_target != null and pass_target != closest_player:
		pass_target.player_control_fsm.transition_to("IdleState")
	closest_player.player_control_fsm.transition_to("ReceivePassState", { "pass_source": self })
	pass_target = closest_player
	

func is_within_layup_range():
	var dist_to_hoop = global_position.distance_to(hoop.global_position)
	return dist_to_hoop <= 250


func handle_input(input: InputEvent):
	if is_selected() and has_ball:
		if Input.is_action_pressed("shoot_ball"):
			if is_within_layup_range():
				player_control_fsm.transition_to("LayupState", {})
			else:
				player_control_fsm.transition_to("ShootState", {})
		if Input.is_action_just_pressed("pass"):
			if pass_target != null:
				player_control_fsm.transition_to("PassState", {})


func pass_ball():
	has_ball = false
	var ball = ball_scene.instantiate() as Ball
	game.ball = ball
	ball.position.x = self.position.x
	ball.position.y = self.position.y
	add_sibling(ball)
	
	pass_target.can_gain_possession = true
	can_gain_possession = false
	var tween = create_tween()
	tween.tween_property(ball, "position", pass_target.position, 0.5)
	tween.finished.connect(on_completed_pass)


func on_completed_pass():
	can_gain_possession = true
	player_control_fsm.transition_to("IdleState", {})


func handle_ball_collision(ball: Ball):
	if self.can_gain_possession:
		self.modulate = Color(1, 1, 1)
		can_gain_possession = false
		player_manager.switch_to_player(self)
		has_ball = true
		game.ball = null
		ball.queue_free()
		player_control_fsm.transition_to("IdleState", {})


func shoot_ball(shot_result: ShotMeter.SHOT_RESULT, arc_duration: float = 1.5, start_position: Vector2 = Vector2(self.position.x, self.position.y - 100)):
	has_ball = false
	var ball = ball_scene.instantiate() as Ball
	ball.position = start_position
	add_sibling(ball)
	game.ball = ball
	ball.disable_player_detector()
	ball.shot_status = shot_result
	ball.curr_poss_status = Ball.POSS_STATUS.SHOOT_UP

	# var camera = player_manager.camera as GameCamera
	# camera.focus_on(ball)
	
	# Detect if this is a 2 point or 3 point shot
	var hoop_to_shoot_at = game.hoop_2 if side == Game.SIDE.CPU else game.hoop_1 as Hoop
	var point_detector = hoop_to_shoot_at.point_detector as Area2D
	var areas = point_detector.get_overlapping_areas()
	var is_within_three_point_line = areas.any(func(a): return a == feet_area)
	last_shot_type = Game.SHOT_TYPE.TWO_POINTER if is_within_three_point_line else Game.SHOT_TYPE.THREE_POINTER
	
	if shot_result == ShotMeter.SHOT_RESULT.MAKE:
		var y_diff = hoop.net.global_position.y - ball.global_position.y
		create_arc(ball, Vector2(hoop.position.x, hoop.net.global_position.y), arc_duration)
	else:
		var x_target_miss_left = randi_range(hoop.position.x - 15, hoop.position.x - 10)
		var x_target_miss_right = randi_range(hoop.position.x + 10, hoop.position.x + 15)
		var x_target = x_target_miss_left if randi_range(0, 1) == 0 else x_target_miss_right
		create_arc(ball, Vector2(x_target, hoop.global_position.y - 10), arc_duration)
		
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
	ball.z_index = hoop.net.z_index + 1
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
	var ball_arc_complete_cb = Callable(self, "on_ball_arc_complete").bind(ball, on_arc_complete_timer)
	on_arc_complete_timer.connect("timeout", ball_arc_complete_cb)
	add_child(on_arc_complete_timer)
	

func jump(custom_jump_complete_cb: Callable, jump_apex_cb: Callable, duration_sec: float):
	self.set_gravity_scale(1)
	var velocity_x = 0
	var velocity_y = ((self.position.y - 50) - self.position.y - 490 * pow(duration_sec, 2)) / duration_sec
	self.linear_velocity = Vector2(velocity_x, velocity_y)
	var jump_peak_timer = Timer.new()

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
	self.set_gravity_scale(0)
	self.linear_velocity = Vector2(0, 0)
	custom_jump_complete_cb.call()
	

func on_ball_arc_complete(ball: Ball, timer: Timer):
	if ball.shot_status == ShotMeter.SHOT_RESULT.MAKE:
		var points_scored = 2 if last_shot_type == Game.SHOT_TYPE.TWO_POINTER else 3
		game.scoreboard.add_score(side, points_scored)
	ball.enable_player_detector()
	can_gain_possession = true
	timer.queue_free()
	

func on_ball_reached_apex(ball: Ball):
	ball.z_index = hoop.net.z_index - 1
	ball.curr_poss_status = Ball.POSS_STATUS.SHOOT_DOWN


func select():
	player_manager.camera.reparent(self)
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
		
