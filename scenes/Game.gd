class_name Game
extends Node2D

@onready var court = $Court
@onready var player_manager = $PlayerManager as PlayerManager
@onready var hoop = $Hoop as Hoop
@onready var camera = $Camera2D
var is_flipped = false
var is_rotating = false
var cached_positions = {}

func _ready():
	camera.limit_left = -500
	camera.limit_right = 500
	camera.limit_top = -300
	camera.limit_bottom = 1110


func rotate_camera():
	for p in player_manager.players:
		cached_positions[p.player_name] = p.global_position
	cached_positions["hoop"] = hoop.global_position
	
	if not is_rotating:
		is_rotating = true
		hoop.hide()
		player_manager.reparent(court)
		hoop.reparent(court)
		var tween = create_tween()
		var final_rotation_rad = deg_to_rad(court.rotation_degrees) + deg_to_rad(180)
		tween.tween_property(court, "rotation", final_rotation_rad, 1.0)
		tween.finished.connect(on_court_rotation_complete)
		
		
func _unhandled_input(event):
	if Input.is_action_just_released("rotate_camera"):
		camera.reparent(self)
		rotate_camera()


func _physics_process(delta):
	if is_rotating:
		for p in player_manager.players:
			var player = p as Player
			player.global_rotation_degrees = 0
			
			
func set_camera_limit():
	camera.limit_top = -1300 if is_flipped else -300
	camera.limit_bottom = 300 if is_flipped else 1110
	print(camera.limit_top)


func on_court_rotation_complete():
	is_rotating = false
	is_flipped = !is_flipped
	
	# Compensate for positional, rotational discrepancies
	for p in player_manager.players:
		var player = p as Player
		player.global_rotation = 0
		var cached_pos_for_player = cached_positions[player.player_name]
		player.global_position = Vector2(-cached_pos_for_player.x, -cached_pos_for_player.y)
		player.global_position.y -= 135 / 2
		
	hoop.global_rotation = 0
	var cached_hoop_position = cached_positions["hoop"]
	hoop.global_position = Vector2(-cached_hoop_position.x, -cached_hoop_position.y)
	hoop.global_position.y -= (hoop.back_sprite.texture.get_height() * hoop.back_sprite.scale.y) / 2
	if is_flipped:
		hoop.display_back()
	else:
		hoop.display_front()
		
	player_manager.reparent(self)
	hoop.reparent(self)
	hoop.show()
	player_manager.reset_camera()
	set_camera_limit()
