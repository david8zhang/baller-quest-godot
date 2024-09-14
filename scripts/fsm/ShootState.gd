class_name ShootState
extends State

var shot_result
var is_released = false

func physics_update(_delta: float) -> void:
	var player = entity as CourtPlayer
	if not is_released:
		player.shot_meter.fill(2, 0.9)
		player.shot_meter.visible = true
	
func update(_delta: float) -> void:
	var player = entity as CourtPlayer
	shot_result = player.shot_meter.get_shot_result()
	
	
func handle_input(_input: InputEvent) -> void:
	var player = entity as CourtPlayer
	if Input.is_action_just_released("shoot_ball"):
		player.shot_meter.display_feedback()
		is_released = true

func enter(_msg:={}):
	var player = entity as CourtPlayer
	player.linear_velocity = Vector2.ZERO
	player.linear_damp = 0
	var anim_name = "shoot-%s-windup" % _get_shoot_anim_angle()
	if anim_name == "shoot-side-windup":
		var x_diff = player.global_position.x - player.hoop_to_shoot_at.position.x
		anim_sprite.flip_h = x_diff > 0
	else:
		anim_sprite.flip_h = false
	anim_sprite.play(anim_name)
	anim_sprite.animation_finished.connect(_shoot_windup_complete)
	
func exit():
	is_released = false
	
func _shoot_windup_complete():
	var player = entity as CourtPlayer
	var anim_name = "shoot-%s-jump" % _get_shoot_anim_angle()
	anim_sprite.animation_finished.disconnect(_shoot_windup_complete)
	anim_sprite.play(anim_name)
	
	var on_jump_complete_callable = Callable(self, "on_jump_complete")
	var on_jump_peak_callable = Callable(self, "on_jump_peak")
	player.jump(on_jump_complete_callable, on_jump_peak_callable, 0.5)


func on_jump_complete():
	var anim_name = "shoot-%s-land" % _get_shoot_anim_angle()
	anim_sprite.play(anim_name)
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 0.1
	timer.timeout.connect(_follow_through_complete)
	add_sibling(timer)


func on_jump_peak():
	var player = entity as CourtPlayer
	var anim_name = "shoot-%s-release" % _get_shoot_anim_angle()
	anim_sprite.play(anim_name)
	player.shoot_ball(shot_result)


func _follow_through_complete():
	var player = entity as CourtPlayer
	player.player_control_fsm.transition_to("IdleState", {})
	
func _get_shoot_anim_angle():
	var player = entity as CourtPlayer
	var x_diff = abs(player.global_position.x - player.hoop_to_shoot_at.global_position.x)
	return "side" if x_diff > 250 else "front"
