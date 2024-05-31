class_name Player
extends RigidBody2D

const SPEED = 300.0
var screen_size
@onready var player_manager: PlayerManager = get_node("/root/Main/PlayerManager")
@onready var hoop: Node2D = get_node("/root/Main/Hoop")
@export var ball_scene: PackedScene

func _ready():
	screen_size = get_viewport_rect().size

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
		position += velocity * delta
		position.x = clamp(position.x, -screen_size.x / 2, screen_size.x / 2)
		position.y = clamp(position.y, -screen_size.y / 2, screen_size.y / 2)
		if velocity.x != 0:
			$Sprite2D.flip_h = velocity.x < 0
			
func _unhandled_input(event):
	if (player_manager.selected_player == self):	
		if Input.is_action_just_pressed("shoot_ball"):
			shoot_ball()

func shoot_ball():
	var ball = ball_scene.instantiate()
	ball.position.x = self.position.x
	ball.position.y = self.position.y
	add_sibling(ball)
	create_arc(ball, Vector2(hoop.position.x, hoop.position.y - 10), 1.5)
	
func create_arc(ball: RigidBody2D, dest_position: Vector2, duration_sec: float):
	var velocity_x = (dest_position.x - ball.position.x) / duration_sec
	var velocity_y = (dest_position.y - ball.position.y - 490 * pow(duration_sec, 2)) / duration_sec
	ball.linear_velocity = Vector2(velocity_x, velocity_y)
	
