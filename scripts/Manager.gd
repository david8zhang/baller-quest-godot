class_name Manager
extends Node

@export var player_scene: PackedScene

var defensive_assigments = {}
var players: Array[Player] = []

func setup_defense():
	pass
	
func init_players(player_configs: Array, side: Game.SIDE):
	for player_config in player_configs:
		var new_player = player_scene.instantiate() as Player
		new_player.side = side
		new_player.player_name = player_config.name
		new_player.player_type = player_config.player_type
		new_player.global_position = player_config.default_position
		players.append(new_player)
		add_child(new_player)

func get_player_by_name(player_name):
	for player in players:
		if player.player_name == player_name:
			return player
	return null
