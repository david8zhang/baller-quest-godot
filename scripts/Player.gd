class_name Player
extends CharacterBody2D

const SPEED = 300.0
var screen_size
@onready var player_manager: PlayerManager = get_node("/root/Main/PlayerManager")

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
