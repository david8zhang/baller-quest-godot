class_name ShootState
extends State

func physics_update(_delta: float) -> void:
	var player = entity as Player
	player.shot_meter.fill(2, 0.9)
	player.shot_meter.visible = true
	
	
func handle_input(input: InputEvent) -> void:
	var player = entity as Player
	if Input.is_action_just_released("shoot_ball"):
		player.shot_meter.display_feedback()
		var shot_result = player.shot_meter.get_shot_result()
		player.shoot_ball(shot_result)
