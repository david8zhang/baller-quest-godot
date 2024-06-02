class_name Player
extends RigidBody2D

const SPEED = 300.0
var screen_size
var pass_target: Player
@onready var player_manager: PlayerManager = get_node("/root/Main/PlayerManager")
@onready var hoop: Hoop = get_node("/root/Main/Hoop") as Hoop
@export var ball_scene: PackedScene
@onready var shot_meter = $ShotMeter as ShotMeter
@onready var highlight = $Highlight

func _ready():
	screen_size = get_viewport_rect().size
	highlight.visible = false

func _physics_process(delta):	
	if (player_manager.selected_player == self):
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
			update_pass_target(velocity)
		position += velocity * delta
		position.x = clamp(position.x, -screen_size.x / 2, screen_size.x / 2)
		position.y = clamp(position.y, -screen_size.y / 2, screen_size.y / 2)
		if velocity.x != 0:
			$Sprite2D.flip_h = velocity.x < 0
			
		if Input.is_action_pressed("shoot_ball"):
			shot_meter.fill(2, 0.9)
			shot_meter.visible = true


func _unhandled_input(event):
	if (player_manager.selected_player == self):	
		if Input.is_action_just_released("shoot_ball"):
			shot_meter.display_feedback()
			var shot_result = shot_meter.get_shot_result()
			shoot_ball(shot_result)
		if Input.is_action_just_pressed("pass"):
			if pass_target != null:
				pass_target.modulate = Color(1, 1, 1)
				player_manager.switch_to_player(pass_target)
				pass_target = null


func update_pass_target(velocity: Vector2):
	if pass_target != null:
		pass_target.modulate = Color(1, 1, 1)
	var src_position = position + velocity
	var closest_player
	var min_dist = INF
	for player in player_manager.players:
		if player != self:
			var dist = src_position.distance_to(player.position)
			if dist < min_dist:
				min_dist = dist
				closest_player = player
	closest_player.show_pass_cursor()
	pass_target = closest_player
	
	
func show_pass_cursor():
	self.modulate = Color(1, 1, 0)


func shoot_ball(shot_result: ShotMeter.SHOT_RESULT):
	var ball = ball_scene.instantiate() as Ball
	ball.position.x = self.position.x
	ball.position.y = self.position.y
	add_sibling(ball)
	if shot_result == ShotMeter.SHOT_RESULT.MAKE:
		print("MAKE!")
		ball.disable_rim_collision()
		hoop.disable_rim_collider()
		create_arc(ball, Vector2(hoop.position.x, hoop.position.y - 10), 1.5)
	else:
		print("MISS!")
		ball.enable_rim_collision()
		hoop.enable_rim_collider()
		var x_target_miss_left = randi_range(hoop.position.x - 15, hoop.position.x - 10)
		var x_target_miss_right = randi_range(hoop.position.x + 10, hoop.position.x + 15)
		var x_target = x_target_miss_left if randi_range(0, 1) == 0 else x_target_miss_right
		create_arc(ball, Vector2(x_target, hoop.position.y - 10), 1.5)
		
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
	var velocity_x = (dest_position.x - ball.position.x) / duration_sec
	var velocity_y = (dest_position.y - ball.position.y - 490 * pow(duration_sec, 2)) / duration_sec
	ball.linear_velocity = Vector2(velocity_x, velocity_y)


func select():
	highlight.visible = true


func deselect():
	highlight.visible = false
