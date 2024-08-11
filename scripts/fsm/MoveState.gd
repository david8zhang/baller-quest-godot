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

	# Ensure player does not exceed court bounds
	var court = player.court as Court
	var court_y_bounds = court.get_y_bounds()
	var court_x_bounds = court.get_x_bounds()
	player.global_position.y = clamp(player.global_position.y, court_y_bounds["upper"], court_y_bounds["lower"])
	player.global_position.x = clamp(player.global_position.x, court_x_bounds["left"], court_x_bounds["right"])

	if velocity.x != 0:
		anim_sprite.flip_h = velocity.x < 0

	var run_anim_name = ""
	if player.has_ball:
		run_anim_name = "dribble-front" if velocity.x == 0 else "dribble-side"
	else:
		run_anim_name = "run-front" if velocity.x == 0 else "run-side"
	anim_sprite.play(run_anim_name)

	if velocity.x == 0 and velocity.y == 0:
		var dir = "HORIZONTAL" if anim_sprite.animation == "run-side" else "VERTICAL"
		state_machine.transition_to("IdleState", {
			"direction": dir
		})


func handle_input(input: InputEvent) -> void:
	var player = entity as Player
	player.handle_input(input)


func enter(msg:={}) -> void:
	var player = entity as Player
	var court_size = player.court.get_size()
