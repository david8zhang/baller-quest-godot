class_name LayupState
extends State

var layup_frame_timings = [
	{
		"frame_index": 0,
		"sec_to_next_frame": 0.2,
		"is_shoot": false
	},
	{
		"frame_index": 1,
		"sec_to_next_frame": 0.2,
		"is_shoot": false
	},
	{
		"frame_index": 2,
		"sec_to_next_frame": 0.2,
		"is_shoot": true
	},
	{
		"frame_index": 3,
		"sec_to_next_frame": 0.2,
		"is_shoot": false
	},
	{
		"frame_index": 4,
		"sec_to_next_frame": 0.2,
		"is_shoot": false
	}
]

func exit():
	var player = entity as Player
	player.set_collision_mask_value(1, true)

func enter(msg := {}):
	var player = entity as Player
	player.set_collision_mask_value(1, false)
	anim_sprite.stop()
	anim_sprite.animation = "layup-front"
	anim_sprite.frame = 0
	var hoop = player.hoop as Hoop
	anim_sprite.z_index = hoop.z_index + 100
	
	var on_jump_complete_callable = Callable(self, "on_jump_complete")
	var on_jump_apex_callable = Callable(self, "on_jump_apex")
	var landing_spot = Vector2(hoop.global_position.x, hoop.global_position.y + 100)
	player.jump_toward(on_jump_complete_callable, on_jump_apex_callable, 1, landing_spot)
	process_layup_frame_timings(0)

func process_layup_frame_timings(timing_index: int):
	if timing_index >= layup_frame_timings.size():
		var player = entity as Player
		player.set_gravity_scale(0)
		return
	var frame_timing = layup_frame_timings[timing_index]
	anim_sprite.frame = frame_timing["frame_index"]
	
	# Shoot the ball if it's the release frame
	if frame_timing["is_shoot"]:
		var player = entity as Player
		var release_position = Vector2(player.global_position.x, player.global_position.y - 55)
		player.shoot_ball(ShotMeter.SHOT_RESULT.MAKE, 1.0, release_position)
	
	var timer = Timer.new()
	timer.wait_time = frame_timing["sec_to_next_frame"]
	timer.autostart = true
	timer.one_shot = true
	var callback = Callable(self, "process_layup_frame_timings").bind(timing_index + 1)
	timer.timeout.connect(callback)
	add_sibling(timer)

func on_jump_apex():
	pass
	
func on_jump_complete():
	var player = entity as Player
	player.player_control_fsm.transition_to("IdleState", {})
	
