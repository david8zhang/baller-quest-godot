extends State

const SPEED = 300.0
var screen_size

# Called when the node enters the scene tree for the first time.
func physics_update(_delta: float) -> void:
	var player = entity as Player
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
		player.update_pass_target(velocity)
	player.global_position += velocity * _delta
	player.global_position.x = clamp(player.global_position.x, -screen_size.x / 2, screen_size.x / 2)
	player.global_position.y = clamp(player.global_position.y, -screen_size.y / 2, screen_size.y / 2)
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
		
	if player.linear_velocity.x == 0 and player.linear_velocity.y == 0:
		state_machine.transition_to("IdleState", {})
			
			
func handle_input(input: InputEvent) -> void:
	var player = entity as Player
	player.handle_input(input)
			
			
func enter(msg:={}) -> void:
	var player = entity as Player
	screen_size = player.get_viewport_rect().size
