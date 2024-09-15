class_name Manager
extends Node

enum TEAM_PHASE {
	IN_OFFENSE,
	IN_DEFENSE,
	SETTING_UP_OFFENSE,
	SETTING_UP_DEFENSE,
	INBOUNDING
}

@export var player_scene: PackedScene
@onready var game = get_node("/root/Main") as Game

var defensive_assigments = {}
var players: Array[CourtPlayer] = []
var inbounder
var inbound_receiver
var curr_team_phase: TEAM_PHASE

func setup_defense():
	pass
	
func init_players(player_configs: Array, side: Game.SIDE):
	for player_config in player_configs:
		var new_player = player_scene.instantiate() as CourtPlayer
		new_player.side = side
		new_player.player_name = player_config.name
		new_player.player_type = player_config.player_type
		new_player.global_position = player_config.default_position
		new_player.hoop_to_shoot_at = game.hoop_1 if side == Game.SIDE.PLAYER else game.hoop_2
		players.append(new_player)
		add_child(new_player)

func get_player_by_name(player_name):
	for player in players:
		if player.player_name == player_name:
			return player
	return null

func get_inbounder_position():
	return Vector2(0, 0)

func get_inbound_receiver_position():
	return Vector2(0, 0)

func assign_inbounder_and_receiver():
	var min_dist = INF
	var player_closest_to_ball = null
	var ball = game.ball

	if ball == null:
		return

	for p in players:
		var dist_to_ball = p.global_position.distance_to(ball.global_position)
		if dist_to_ball < min_dist and p.player_type != Game.PLAYER_TYPE.POINT_GUARD:
			dist_to_ball = min_dist
			player_closest_to_ball = p
	
	# Inbound passer is player closest to the ball (who's not the PG since they're the inbound receiver)
	inbounder = player_closest_to_ball
	inbound_receiver = get_player_by_position(Game.PLAYER_TYPE.POINT_GUARD)

func get_player_by_position(player_type: Game.PLAYER_TYPE):
	for player in players:
		if player.player_type == player_type:
			return player
	return name

func get_defensive_positions():
	return {}

func get_offensive_positions():
	return {}

# Remove inbounder
func on_inbound_complete():
	inbounder = null
	inbound_receiver = null
	curr_team_phase = TEAM_PHASE.SETTING_UP_OFFENSE