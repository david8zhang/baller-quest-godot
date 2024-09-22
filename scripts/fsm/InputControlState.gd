class_name InputControlState
extends State
var screen_size

# Called when the node enters the scene tree for the first time.
func physics_update(_delta: float) -> void:
	var player = entity as CourtPlayer
	player.linear_damp = 0
	var velocity = Vector2.ZERO
	if player.side == Game.SIDE.PLAYER:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * CourtPlayer.SPEED
			player.update_pass_or_switch_target(velocity)
		player.linear_velocity = velocity

	if velocity.x != 0:
		anim_sprite.flip_h = velocity.x < 0

	# Play appropriate animation depending on if player has the ball or not
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


# func handle_input(input: InputEvent) -> void:
# 	var player = entity as CourtPlayer
# 	player.handle_input(input)
