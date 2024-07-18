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
	anim_sprite.play("shoot-windup")
	anim_sprite.animation_finished.connect(_shoot_windup_complete)
	
func exit():
	is_released = false
	
func _shoot_windup_complete():
	var player = entity as Player
	anim_sprite.animation_finished.disconnect(_shoot_windup_complete)
	anim_sprite.play("shoot-jump")
	
	var on_jump_complete_callable = Callable(self, "on_jump_complete")
	var on_jump_peak_callable = Callable(self, "on_jump_peak")
	player.jump(on_jump_complete_callable, on_jump_peak_callable, 0.5)


func on_jump_complete():
	var player = entity as Player
	anim_sprite.play("shoot-land")
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 0.1
	timer.timeout.connect(_follow_through_complete)
	add_sibling(timer)


func on_jump_peak():
	var player = entity as Player
	anim_sprite.play("shoot-release")
	player.shoot_ball(shot_result)


func _follow_through_complete():
	var player = entity as Player
	player._state_machine.transition_to("IdleState", {})
