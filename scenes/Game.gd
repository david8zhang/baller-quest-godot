class_name Game
extends Node2D

@onready var court = $Court
@onready var player_manager = $PlayerManager
@onready var hoop = $Hoop as Hoop
var is_rotated = false
var is_rotating = false


func rotate_camera():
	if not is_rotating:
		print("Rotating court!")
		is_rotating = true
		var tween = create_tween()
		var final_rotation_rad = deg_to_rad(court.rotation_degrees) + deg_to_rad(180)
		tween.tween_property(court, "rotation", final_rotation_rad, 2.5)
		tween.finished.connect(on_court_rotation_complete)
		hoop.hide()
		player_manager.reparent(court)
		hoop.reparent(court)
		
		
func _unhandled_input(event):
	if Input.is_action_just_released("rotate_camera"):
		rotate_camera()


func _physics_process(delta):
	if is_rotating:
		for p in player_manager.players:
			var player = p as Player
			player.global_rotation_degrees = 0


func on_court_rotation_complete():
	is_rotating = false
	is_rotated = !is_rotated
	for p in player_manager.players:
		var player = p as Player
		player.global_rotation = 0
	hoop.global_rotation = 0
	player_manager.reparent(self)
	hoop.reparent(self)
	hoop.show()
	hoop.display_back()
