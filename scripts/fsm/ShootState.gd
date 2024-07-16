class_name ShootState
extends State

var shot_result
var is_released = false

func physics_update(_delta: float) -> void:
	var player = entity as Player
	if not is_released:
		player.shot_meter.fill(2, 0.9)
		player.shot_meter.visible = true
	
func update(_delta: float) -> void:
	var player = entity as Player
	shot_result = player.shot_meter.get_shot_result()
	
	
func handle_input(input: InputEvent) -> void:
	var player = entity as Player
	if Input.is_action_just_released("shoot_ball"):
		player.shot_meter.display_feedback()
		is_released = true

func enter(msg:={}):
	anim_sprite.play("shoot-front")
	anim_sprite.frame_changed.connect(_shoot_anim_frame_changed)
	anim_sprite.animation_finished.connect(_shoot_anim_completed)
	
func exit():
	is_released = false
	
func _shoot_anim_frame_changed():
	var player = entity as Player
	if anim_sprite.frame == 4:
		player.shoot_ball(ShotMeter.SHOT_RESULT.MAKE)
		anim_sprite.frame_changed.disconnect(_shoot_anim_frame_changed)
		
func _shoot_anim_completed():
	var player = entity as Player
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.timeout.connect(_follow_through_complete)
	add_sibling(timer)
	
	
func _follow_through_complete():
	var player = entity as Player
	player._state_machine.transition_to("IdleState", {})
