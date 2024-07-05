class_name IdleState
extends State

func update(_delta: float) -> void:
	var player = entity as Player
	var player_manager = player.player_manager
	if player.is_selected():
		var right_pressed = Input.is_action_pressed("move_right")
		var left_pressed = Input.is_action_pressed("move_left")
		var down_pressed = Input.is_action_pressed("move_down")
		var up_pressed = Input.is_action_pressed("move_up")
		if right_pressed or left_pressed or down_pressed or up_pressed:
			state_machine.transition_to("MoveState", {})


func handle_input(input: InputEvent) -> void:
	var player = entity as Player
	player.handle_input(input)

func enter(msg := {}):
	if msg.has("direction"):
		var dir = msg["direction"]
		if dir == "HORIZONTAL":
			anim_sprite.play("idle-side")
		else:
			anim_sprite.play("idle-front")
	else:
		anim_sprite.play("idle-front")
